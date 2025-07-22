variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "board_game_app"
}

variable "environment" {
  description = "환경 (dev, staging, prod)"
  type        = string
  default     = "dev"
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
