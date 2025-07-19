output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "vpc_cidr_block" {
  description = "VPC CIDR 블록"
  value       = module.vpc.vpc_cidr_block
}

output "subnet_ids" {
  description = "서브넷 ID 목록"
  value       = module.vpc.subnet_ids
}

output "internet_gateway_id" {
  description = "인터넷 게이트웨이 ID"
  value       = module.vpc.internet_gateway_id
}

output "route_table_id" {
  description = "라우팅 테이블 ID"
  value       = module.vpc.route_table_id
}

# EC2 출력
output "ec2_instance_id" {
  description = "EC2 인스턴스 ID"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "EC2 인스턴스 공인 IP"
  value       = module.ec2.public_ip
}

output "ec2_public_dns" {
  description = "EC2 인스턴스 공인 DNS"
  value       = module.ec2.public_dns
}

# ECR 출력
output "ecr_repository_url" {
  description = "ECR 리포지토리 URL"
  value       = module.ecr.repository_url
}

output "ecr_repository_name" {
  description = "ECR 리포지토리 이름"
  value       = module.ecr.repository_name
}

output "ecr_repository_arn" {
  description = "ECR 리포지토리 ARN"
  value       = module.ecr.repository_arn
}
