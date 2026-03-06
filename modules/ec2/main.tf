# Amazon Linux 2023 ARM64 최신 AMI 조회
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*-arm64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "main" {
  count = var.enabled ? 1 : 0

  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile_name # IAM 인스턴스 프로파일 추가

  # 루트 볼륨 설정
  root_block_device {
    volume_size = 30
    volume_type = "gp3"
    encrypted   = true
  }

  tags = {
    Name = "${var.project_name}-ec2"
  }

  # 사용자 데이터 스크립트 - 외부 파일 사용
  user_data = file("${path.module}/user_data.sh")
}

# Elastic IP 할당
resource "aws_eip" "main" {
  count = var.enabled ? 1 : 0

  instance = aws_instance.main[0].id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
} 