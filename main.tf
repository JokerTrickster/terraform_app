# VPC 모듈
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  environment          = var.environment
  project_name         = var.project_name
}

# IAM 모듈
module "iam" {
  source = "./modules/iam"
  
  environment  = var.environment
  project_name = var.project_name
}

# Security Group 모듈
module "security" {
  source = "./modules/security"
  
  vpc_id       = module.vpc.vpc_id
  environment  = var.environment
  project_name = var.project_name
}

# EC2 모듈 (기존 + GitHub Actions Runner)
module "ec2" {
  source = "./modules/ec2"
  
  vpc_id                    = module.vpc.vpc_id
  subnet_id                 = module.vpc.subnet_ids[0]  # 첫 번째 서브넷 사용
  security_group_id         = module.security.security_group_id
  instance_type             = var.instance_type
  key_name                  = var.key_name
  environment               = var.environment
  project_name              = var.project_name
  iam_instance_profile_name = module.iam.ec2_instance_profile_name
}

# ECR 모듈
module "ecr" {
  source = "./modules/ecr"
  
  environment  = var.environment
  project_name = var.project_name
}

# SSM 모듈
module "ssm" {
  source = "./modules/ssm"
  
  project_name                = var.project_name
  dev_frog_redis_user       = var.dev_frog_redis_user
  dev_common_redis_host     = var.dev_common_redis_host
  dev_common_redis_port     = var.dev_common_redis_port
  dev_frog_redis_db         = var.dev_frog_redis_db
  dev_frog_mysql_user       = var.dev_frog_mysql_user
  dev_common_mysql_host     = var.dev_common_mysql_host
  dev_common_mysql_port     = var.dev_common_mysql_port
  dev_frog_mysql_db         = var.dev_frog_mysql_db
  dev_frog_rabbitmq_user    = var.dev_frog_rabbitmq_user
  dev_frog_rabbitmq_host    = var.dev_frog_rabbitmq_host
  dev_frog_rabbitmq_port    = var.dev_frog_rabbitmq_port
}

# S3 모듈
module "s3" {
  source = "./modules/s3"

  bucket_name   = "board-game-app"
  environment   = var.environment
  project_name  = var.project_name
}

# Workflow Hosting 모듈 (S3 + CloudFront)
module "workflow_hosting" {
  source = "./modules/workflow-hosting"

  bucket_name  = "jokertrickster-workflow"
  environment  = "prod"
  project_name = "workflow"
}
