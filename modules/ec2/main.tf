# 기존 EC2 인스턴스 생성 (t4g.medium)
resource "aws_instance" "main" {
  ami                    = "ami-02f607855bfce66b6"  # Amazon Linux 2023 AMI for ap-south-1
  instance_type          = "t4g.medium"             # ARM64 기반 인스턴스
  key_name               = var.key_name
  vpc_security_group_ids = [var.security_group_id]
  subnet_id              = var.subnet_id
  iam_instance_profile   = var.iam_instance_profile_name  # IAM 인스턴스 프로파일 추가

  tags = {
    Name = "${var.project_name}-ec2"
  }

  # 사용자 데이터 스크립트 - 외부 파일 사용
  user_data = file("${path.module}/user_data.sh")
}

# Elastic IP 할당
resource "aws_eip" "main" {
  instance = aws_instance.main.id
  domain   = "vpc"

  tags = {
    Name = "${var.project_name}-eip"
  }
} 