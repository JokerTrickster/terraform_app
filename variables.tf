variable "aws_region" {
  description = "AWS 리전"
  type        = string
  default     = "ap-south-1"
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "board_game_app"
}

variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type        = string
  default     = "t4g.medium"
}

variable "key_name" {
  description = "EC2 키 페어 이름"
  type        = string
  default     = "logan.cho.home"
}

variable "dev_frog_redis_user" {
  description = "Redis user"
  type        = string
  default     = "board"
}

variable "dev_common_redis_host" {
  description = "Redis host"
  type        = string
  default     = "redis"
}

variable "dev_common_redis_port" {
  description = "Redis port"
  type        = string
  default     = "6379"
}

variable "dev_frog_redis_db" {
  description = "Redis db"
  type        = string
  default     = "1"
}

variable "dev_frog_mysql_user" {
  description = "MySQL user"
  type        = string
  default     = "board"
}

variable "dev_common_mysql_host" {
  description = "MySQL host"
  type        = string
  default     = "mysql"
}

variable "dev_common_mysql_port" {
  description = "MySQL port"
  type        = string
  default     = "3306"
}

variable "dev_frog_mysql_db" {
  description = "MySQL db name"
  type        = string
  default     = "dev_frog"
}

variable "dev_frog_rabbitmq_user" {
  description = "RabbitMQ user"
  type        = string
  default     = "board"
}


variable "dev_frog_rabbitmq_host" {
  description = "RabbitMQ host"
  type        = string
  default     = "rabbitmq"
}

variable "dev_frog_rabbitmq_port" {
  description = "RabbitMQ port"
  type        = string
  default     = "5672"
}

variable "dev_frog_mysql_password" {
  description = "MySQL password"
  type        = string
  sensitive   = true
  default     = "changeme"
}

variable "dev_frog_redis_password" {
  description = "Redis password"
  type        = string
  sensitive   = true
  default     = "changeme"
}

variable "dev_frog_rabbitmq_password" {
  description = "RabbitMQ password"
  type        = string
  sensitive   = true
  default     = "changeme"
}
