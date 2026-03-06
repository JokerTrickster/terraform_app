aws_region   = "ap-south-1"
environment  = "dev"
project_name = "board_game_app"

# EC2
instance_type = "t4g.medium"
key_name      = "logan.cho.home"

# Redis
dev_frog_redis_user   = "board"
dev_common_redis_host = "redis"
dev_common_redis_port = "6379"
dev_frog_redis_db     = "1"

# MySQL
dev_frog_mysql_user   = "board"
dev_common_mysql_host = "mysql"
dev_common_mysql_port = "3306"
dev_frog_mysql_db     = "dev_frog"

# RabbitMQ
dev_frog_rabbitmq_user = "board"
dev_frog_rabbitmq_host = "rabbitmq"
dev_frog_rabbitmq_port = "5672"

# Passwords - override via environment variables or CLI
# export TF_VAR_dev_frog_mysql_password="your-password"
# export TF_VAR_dev_frog_redis_password="your-password"
# export TF_VAR_dev_frog_rabbitmq_password="your-password"
