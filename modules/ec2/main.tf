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

# EC2 인스턴스 생성 (프리티어)
resource "aws_instance" "main" {
  ami                    = "ami-0c9c942bd7bf113a2"  # Amazon Linux 2023 AMI for ap-northeast-2
  instance_type          = "t2.micro"               # 프리티어
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id

  tags = {
    Name = "${var.project_name}-ec2"
  }

  # 사용자 데이터 스크립트 (선택사항)
  user_data = <<-EOF
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello from Terraform!</h1>" > /var/www/html/index.html
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