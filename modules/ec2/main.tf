# 최신 Amazon Linux 2 AMI 조회
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# 기존 EC2 인스턴스 생성 (프리티어)
resource "aws_instance" "main" {
  ami                    = "ami-0c9c942bd7bf113a2"  # Amazon Linux 2023 AMI for ap-northeast-2
  instance_type          = "t2.micro"               # 프리티어
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile_name  # IAM 인스턴스 프로파일 추가

  tags = {
    Name = "${var.project_name}-ec2"
  }

  # 사용자 데이터 스크립트 - Docker 설치 및 ECR 스크립트 추가
  user_data = <<-EOF
              #!/bin/bash
              # 시스템 업데이트
              apt-get update
              
              # Docker 설치
              apt-get install -y docker.io
              systemctl start docker
              systemctl enable docker
              
              # 현재 사용자를 docker 그룹에 추가
              usermod -a -G docker ubuntu
              
              # Docker Compose 설치
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              
              # Docker 서비스 시작
              systemctl start docker
              systemctl enable docker
              
              # AWS CLI v2 설치
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install
              rm -rf aws awscliv2.zip
              
              # ECR 컨테이너 실행 스크립트 생성
              cat > /home/ubuntu/server_start.sh << 'SCRIPT'
              #!/bin/bash

              # 변수 설정
              AWS_REGION="ap-northeast-2"
              REPOSITORY="298483610289.dkr.ecr.$AWS_REGION.amazonaws.com/dev_frog"
              TAG="dev_latest"
              CONTAINER_NAME="dev_frog_container"
              PORT="8080"

              echo "[1/4] ECR 로그인 중..."
              aws ecr get-login-password --region $AWS_REGION | \
                sudo docker login --username AWS \
                --password-stdin 298483610289.dkr.ecr.$AWS_REGION.amazonaws.com

              if [ $? -ne 0 ]; then
                echo "❌ ECR 로그인 실패"
                exit 1
              fi

              echo "[2/4] Docker 이미지 pull 중..."
              sudo docker pull $REPOSITORY:$TAG

              if [ $? -ne 0 ]; then
                echo "❌ Docker 이미지 pull 실패"
                exit 1
              fi

              echo "[3/4] 기존 컨테이너 정리..."
              sudo docker rm -f $CONTAINER_NAME 2>/dev/null

              echo "[4/4] 컨테이너 실행 중..."
              sudo docker run -d \
                --name $CONTAINER_NAME \
                -p $PORT:$PORT \
                $REPOSITORY:$TAG

              if [ $? -eq 0 ]; then
                echo "✅ 컨테이너 '$CONTAINER_NAME' 실행 완료!"
              else
                echo "❌ 컨테이너 실행 실패"
              fi
              SCRIPT
              
              # 스크립트 실행 권한 부여
              chmod +x /home/ubuntu/server_start.sh
              
              # ubuntu 소유권 변경
              chown ubuntu:ubuntu /home/ubuntu/server_start.sh
              
              echo "Docker installation completed!"
              echo "ECR container script created at: /home/ubuntu/server_start.sh"
              echo "To run the container: ./server_start.sh"
              EOF
}

# Elastic IP 할당
resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
}

# GitHub Actions Runner용 EC2 인스턴스 생성
resource "aws_instance" "runner" {
  ami                    = "ami-0c9c942bd7bf113a2"  # Amazon Linux 2023 AMI for ap-northeast-2
  instance_type          = "t2.medium"              # 빌드 배포용
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile_name  # IAM 인스턴스 프로파일 추가

  # 빌드 배포용 최적화 설정
  root_block_device {
    volume_size = 50  # 50GB 스토리지
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name        = "${var.project_name}-github-runner"
    Purpose     = "GitHub Actions Runner"
    Environment = var.environment
    AutoStop    = "true"  # 자동 중지 태그
  }

  # GitHub Actions Runner 설치 및 설정
  user_data = <<-EOF
              #!/bin/bash
              # 시스템 업데이트
              yum update -y

              # Docker 설치
              yum install -y docker
              systemctl start docker
              systemctl enable docker

              # 현재 사용자를 docker 그룹에 추가
              usermod -a -G docker ec2-user
              
              # Docker Compose 설치
              curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
              chmod +x /usr/local/bin/docker-compose
              
              # Docker 서비스 시작
              systemctl start docker
              systemctl enable docker

              # Node.js 설치 (빌드용)
              curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
              yum install -y nodejs
              
              # Java 설치 (빌드용)
              yum install -y java-11-amazon-corretto
              
              # Python 3.9 설치
              yum install -y python3 python3-pip
              
              # AWS CLI v2 설치
              curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
              unzip awscliv2.zip
              ./aws/install
              rm -rf aws awscliv2.zip
              
              # AWS CLI 버전 확인
              aws --version
              
              # GitHub Actions Runner 설치
              mkdir -p /opt/actions-runner
              cd /opt/actions-runner
              curl -o actions-runner-linux-x64-2.311.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.311.0/actions-runner-linux-x64-2.311.0.tar.gz
              tar xzf ./actions-runner-linux-x64-2.311.0.tar.gz
              rm actions-runner-linux-x64-2.311.0.tar.gz
              
              # Runner 설정 (나중에 수동으로 완료)
              # ./config.sh --url https://github.com/YOUR_ORG/YOUR_REPO --token YOUR_TOKEN
              
              # 자동 시작 스크립트 생성
              cat > /opt/start-runner.sh << 'SCRIPT'
              #!/bin/bash
              cd /opt/actions-runner
              ./run.sh
              SCRIPT
              chmod +x /opt/start-runner.sh
              
              # 시스템 서비스로 등록
              cat > /etc/systemd/system/github-runner.service << 'SERVICE'
              [Unit]
              Description=GitHub Actions Runner
              After=network.target
              
              [Service]
              Type=simple
              User=root
              WorkingDirectory=/opt/actions-runner
              ExecStart=/opt/actions-runner/run.sh
              Restart=always
              RestartSec=10
              
              [Install]
              WantedBy=multi-user.target
              SERVICE
              
              systemctl daemon-reload
              systemctl enable github-runner.service
              
              echo "GitHub Actions Runner installation completed!"
              echo "Please configure the runner with:"
              echo "cd /opt/actions-runner"
              echo "./config.sh --url https://github.com/YOUR_ORG/YOUR_REPO --token YOUR_TOKEN"
              EOF
}

# GitHub Actions Runner용 Elastic IP 할당
resource "aws_eip" "runner" {
  instance = aws_instance.runner.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-runner-eip"
  }
} 