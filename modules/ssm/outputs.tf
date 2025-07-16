output "google_client_id_arn" {
  description = "Google Client ID 파라미터 ARN"
  value       = aws_ssm_parameter.google_client_id.arn
}

output "google_client_id_name" {
  description = "Google Client ID 파라미터 이름"
  value       = aws_ssm_parameter.google_client_id.name
}

output "google_client_secret_arn" {
  description = "Google Client Secret 파라미터 ARN"
  value       = aws_ssm_parameter.google_client_secret.arn
}

output "app_google_client_id_arn" {
  description = "App Google Client ID 파라미터 ARN"
  value       = aws_ssm_parameter.app_google_client_id.arn
}

output "app_google_client_secret_arn" {
  description = "App Google Client Secret 파라미터 ARN"
  value       = aws_ssm_parameter.app_google_client_secret.arn
}

output "frog_aes_key_arn" {
  description = "Frog AES Key 파라미터 ARN"
  value       = aws_ssm_parameter.frog_aes_key.arn
}

output "dev_frog_redis_user_arn" {
  description = "Dev Frog Redis User 파라미터 ARN"
  value       = aws_ssm_parameter.dev_frog_redis_user.arn
}

output "dev_frog_redis_password_arn" {
  description = "Dev Frog Redis Password 파라미터 ARN"
  value       = aws_ssm_parameter.dev_frog_redis_password.arn
}

output "dev_common_redis_host_arn" {
  description = "Dev Common Redis Host 파라미터 ARN"
  value       = aws_ssm_parameter.dev_common_redis_host.arn
}

output "dev_common_redis_port_arn" {
  description = "Dev Common Redis Port 파라미터 ARN"
  value       = aws_ssm_parameter.dev_common_redis_port.arn
}

output "dev_frog_redis_db_arn" {
  description = "Dev Frog Redis DB 파라미터 ARN"
  value       = aws_ssm_parameter.dev_frog_redis_db.arn
}

output "dev_frog_mysql_user_arn" {
  description = "Dev Frog MySQL User 파라미터 ARN"
  value       = aws_ssm_parameter.dev_frog_mysql_user.arn
}

output "dev_common_mysql_password_arn" {
  description = "Dev Common MySQL Password 파라미터 ARN"
  value       = aws_ssm_parameter.dev_common_mysql_password.arn
}

output "dev_common_mysql_host_arn" {
  description = "Dev Common MySQL Host 파라미터 ARN"
  value       = aws_ssm_parameter.dev_common_mysql_host.arn
}

output "dev_common_mysql_port_arn" {
  description = "Dev Common MySQL Port 파라미터 ARN"
  value       = aws_ssm_parameter.dev_common_mysql_port.arn
}

output "dev_frog_mysql_db_arn" {
  description = "Dev Frog MySQL DB 파라미터 ARN"
  value       = aws_ssm_parameter.dev_frog_mysql_db.arn
}

output "frog_firebase_service_key_arn" {
  description = "Frog Firebase Service Key 파라미터 ARN"
  value       = aws_ssm_parameter.frog_firebase_service_key.arn
} 