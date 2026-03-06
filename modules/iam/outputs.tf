output "ec2_role_arn" {
  description = "EC2 IAM 역할 ARN"
  value       = var.enabled ? aws_iam_role.ec2_role[0].arn : null
}

output "ec2_instance_profile_name" {
  description = "EC2 인스턴스 프로파일 이름"
  value       = var.enabled ? aws_iam_instance_profile.ec2_profile[0].name : null
}
