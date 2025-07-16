# GOOGLE_CLIENT_ID 파라미터 생성
resource "aws_ssm_parameter" "google_client_id" {
  name        = "google_client_id"
  description = "Google OAuth Client ID for ${var.project_name}"
  type        = "SecureString"
  value       = var.google_client_id

  tags = {
    Name        = "google-client-id"
    Environment = var.environment
    Project     = var.project_name
  }
}

# GOOGLE_CLIENT_SECRET 파라미터 생성
resource "aws_ssm_parameter" "google_client_secret" {
  name        = "google_client_secret"
  description = "Google OAuth Client Secret for ${var.project_name}"
  type        = "SecureString"
  value       = var.google_client_secret

  tags = {
    Name        = "google-client-secret"
    Environment = var.environment
    Project     = var.project_name
  }
}

# APP_GOOGLE_CLIENT_ID 파라미터 생성
resource "aws_ssm_parameter" "app_google_client_id" {
  name        = "app_google_client_id"
  description = "App Google OAuth Client ID for ${var.project_name}"
  type        = "SecureString"
  value       = var.app_google_client_id

  tags = {
    Name        = "app-google-client-id"
    Environment = var.environment
    Project     = var.project_name
  }
}

# APP_GOOGLE_CLIENT_SECRET 파라미터 생성
resource "aws_ssm_parameter" "app_google_client_secret" {
  name        = "app_google_client_secret"
  description = "App Google OAuth Client Secret for ${var.project_name}"
  type        = "SecureString"
  value       = var.app_google_client_secret

  tags = {
    Name        = "app-google-client-secret"
    Environment = var.environment
    Project     = var.project_name
  }
}

# FROG_AES_KEY 파라미터 생성
resource "aws_ssm_parameter" "frog_aes_key" {
  name        = "frog_aes_key"
  description = "Frog AES Key for ${var.project_name}"
  type        = "SecureString"
  value       = var.frog_aes_key

  tags = {
    Name        = "frog-aes-key"
    Environment = var.environment
    Project     = var.project_name
  }
}

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

# DEV_FROG_REDIS_PASSWORD 파라미터 생성
resource "aws_ssm_parameter" "dev_frog_redis_password" {
  name        = "dev_frog_redis_password"
  description = "Dev Frog Redis Password for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_frog_redis_password

  tags = {
    Name        = "dev-frog-redis-password"
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

# DEV_COMMON_MYSQL_PASSWORD 파라미터 생성
resource "aws_ssm_parameter" "dev_common_mysql_password" {
  name        = "dev_common_mysql_password"
  description = "Dev Common MySQL Password for ${var.project_name}"
  type        = "SecureString"
  value       = var.dev_common_mysql_password

  tags = {
    Name        = "dev-common-mysql-password"
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

# FROG_FIREBASE_SERVICE_KEY 파라미터 생성
resource "aws_ssm_parameter" "frog_firebase_service_key" {
  name        = "frog_firebase_service_key"
  description = "Frog Firebase Service Key for ${var.project_name}"
  type        = "SecureString"
  value       = var.frog_firebase_service_key

  tags = {
    Name        = "frog-firebase-service-key"
    Environment = var.environment
    Project     = var.project_name
  }
} 