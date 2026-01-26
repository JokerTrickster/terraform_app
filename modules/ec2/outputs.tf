output "instance_id" {
  description = "EC2 인스턴스 ID"
  value       = var.enabled ? aws_instance.main[0].id : null
}

output "public_ip" {
  description = "EC2 인스턴스 공인 IP"
  value       = var.enabled ? aws_eip.main[0].public_ip : null
}

output "public_dns" {
  description = "EC2 인스턴스 공인 DNS"
  value       = var.enabled ? aws_eip.main[0].public_dns : null
}

output "private_ip" {
  description = "EC2 인스턴스 사설 IP"
  value       = var.enabled ? aws_instance.main[0].private_ip : null
} 