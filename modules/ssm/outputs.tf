
output "dev_frog_redis_user_arn" {
  description = "Dev Frog Redis User 파라미터 ARN"
  value       = aws_ssm_parameter.dev_frog_redis_user.arn
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


output "dev_frog_rabbitmq_user_arn" {
  description = "Dev Frog RabbitMQ User 파라미터 ARN"
  value       = aws_ssm_parameter.dev_frog_rabbitmq_user.arn
}


output "dev_frog_rabbitmq_port_arn" {
  description = "Dev Frog RabbitMQ Port 파라미터 ARN"
  value       = aws_ssm_parameter.dev_frog_rabbitmq_port.arn
} 

output "dev_frog_rabbitmq_host_arn" {
  description = "Dev Frog RabbitMQ Host 파라미터 ARN"
  value       = aws_ssm_parameter.dev_frog_rabbitmq_host.arn
} 