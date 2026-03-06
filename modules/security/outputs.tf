output "security_group_id" {
  description = "보안 그룹 ID"
  value       = var.enabled ? aws_security_group.main[0].id : null
}
