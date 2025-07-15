# VPC 모듈
module "vpc" {
  source = "./modules/vpc"
  
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidr   = var.public_subnet_cidr
  environment          = var.environment
  project_name         = var.project_name
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
  
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.subnet_ids[0]  # 첫 번째 서브넷 사용
  security_group_id = module.security.security_group_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  environment       = var.environment
  project_name      = var.project_name
}
