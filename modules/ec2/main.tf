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

  tags = {
    Name = "${var.project_name}-ec2"
  }

  # 사용자 데이터 스크립트 - Docker 설치
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
              
              # 간단한 테스트용 웹 서버 실행 (선택사항)
              docker run -d -p 80:80 --name nginx-test nginx:alpine
              
              echo "Docker installation completed!"
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
              
              echo "GitHub Actions Runner installation completed!"
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