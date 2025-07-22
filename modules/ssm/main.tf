
# DEV_FROG_REDIS_USER 파라미터 생성
resource "aws_ssm_parameter" "dev_frog_redis_user" {
  name        = "dev_frog_redis_user"
  description = "Dev Frog Redis User for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_frog_redis_user

  tags = {
    Name        = "dev-frog-redis-user"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_COMMON_REDIS_HOST 파라미터 생성
resource "aws_ssm_parameter" "dev_common_redis_host" {
  name        = "dev_common_redis_host"
  description = "Dev Common Redis Host for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_common_redis_host

  tags = {
    Name        = "dev-common-redis-host"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_COMMON_REDIS_PORT 파라미터 생성
resource "aws_ssm_parameter" "dev_common_redis_port" {
  name        = "dev_common_redis_port"
  description = "Dev Common Redis Port for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_common_redis_port

  tags = {
    Name        = "dev-common-redis-port"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_FROG_REDIS_DB 파라미터 생성
resource "aws_ssm_parameter" "dev_frog_redis_db" {
  name        = "dev_frog_redis_db"
  description = "Dev Frog Redis DB for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_frog_redis_db

  tags = {
    Name        = "dev-frog-redis-db"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_FROG_MYSQL_USER 파라미터 생성
resource "aws_ssm_parameter" "dev_frog_mysql_user" {
  name        = "dev_frog_mysql_user"
  description = "Dev Frog MySQL User for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_frog_mysql_user

  tags = {
    Name        = "dev-frog-mysql-user"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_COMMON_MYSQL_HOST 파라미터 생성
resource "aws_ssm_parameter" "dev_common_mysql_host" {
  name        = "dev_common_mysql_host"
  description = "Dev Common MySQL Host for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_common_mysql_host

  tags = {
    Name        = "dev-common-mysql-host"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_COMMON_MYSQL_PORT 파라미터 생성
resource "aws_ssm_parameter" "dev_common_mysql_port" {
  name        = "dev_common_mysql_port"
  description = "Dev Common MySQL Port for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_common_mysql_port

  tags = {
    Name        = "dev-common-mysql-port"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_FROG_MYSQL_DB 파라미터 생성
resource "aws_ssm_parameter" "dev_frog_mysql_db" {
  name        = "dev_frog_mysql_db"
  description = "Dev Frog MySQL DB for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_frog_mysql_db

  tags = {
    Name        = "dev-frog-mysql-db"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_FROG_RABBITMQ_USER 파라미터 생성
resource "aws_ssm_parameter" "dev_frog_rabbitmq_user" {
  name        = "dev_frog_rabbitmq_user"
  description = "Dev Frog RabbitMQ User for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_frog_rabbitmq_user

  tags = {
    Name        = "dev-frog-rabbitmq-user"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_FROG_RABBITMQ_HOST 파라미터 생성
resource "aws_ssm_parameter" "dev_frog_rabbitmq_host" {
  name        = "dev_frog_rabbitmq_host"
  description = "Dev Frog RabbitMQ Host for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_frog_rabbitmq_host

  tags = {
    Name        = "dev-frog-rabbitmq-host"
    Environment = var.environment
    Project     = var.project_name
  }
}

# DEV_FROG_RABBITMQ_PORT 파라미터 생성
resource "aws_ssm_parameter" "dev_frog_rabbitmq_port" {
  name        = "dev_frog_rabbitmq_port"
  description = "Dev Frog RabbitMQ Port for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_frog_rabbitmq_port

  tags = {
    Name        = "dev-frog-rabbitmq-port"
    Environment = var.environment
    Project     = var.project_name
  }
} 