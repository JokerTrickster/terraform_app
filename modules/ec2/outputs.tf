output "instance_id" {
  description = "EC2 인스턴스 ID"
  value       = aws_instance.main.id
}

output "public_ip" {
  description = "EC2 인스턴스 공인 IP"
  value       = aws_eip.main.public_ip
}

output "public_dns" {
  description = "EC2 인스턴스 공인 DNS"
  value       = aws_eip.main.public_dns
}

output "private_ip" {
  description = "EC2 인스턴스 사설 IP"
  value       = aws_instance.main.private_ip
} 