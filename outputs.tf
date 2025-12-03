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

# S3 출력
output "s3_bucket_id" {
  description = "S3 버킷 ID"
  value       = module.s3.bucket_id
}

output "s3_bucket_arn" {
  description = "S3 버킷 ARN"
  value       = module.s3.bucket_arn
}

output "s3_bucket_name" {
  description = "S3 버킷 이름"
  value       = module.s3.bucket_name
}

output "backend_bucket_name" {
  description = "백엔드 S3 버킷 이름"
  value       = module.s3.backend_bucket_name
}

# Workflow Hosting 출력
output "workflow_s3_website_url" {
  description = "Workflow S3 Website URL"
  value       = module.workflow_hosting.s3_website_url
}

output "workflow_s3_bucket_name" {
  description = "Workflow S3 Bucket Name"
  value       = module.workflow_hosting.s3_bucket_name
}

output "workflow_iam_user_name" {
  description = "Workflow IAM User Name for GitHub Actions"
  value       = module.workflow_hosting.iam_user_name
}

# Cloud Repository 출력
output "cloud_repository_bucket_name" {
  description = "Cloud Repository S3 Bucket Name"
  value       = module.s3_cloud_repository.bucket_name
}

output "cloud_repository_website_endpoint" {
  description = "Cloud Repository Website Endpoint"
  value       = module.s3_cloud_repository.website_endpoint
}

output "cloud_repository_website_url" {
  description = "Cloud Repository Website URL"
  value       = "http://${module.s3_cloud_repository.website_endpoint}"
}

output "cloud_repository_iam_user" {
  description = "Cloud Repository IAM User Name for GitHub Actions"
  value       = module.s3_cloud_repository.iam_user_name
}

output "cloud_repository_access_key_id" {
  description = "Cloud Repository Access Key ID for GitHub Actions"
  value       = module.s3_cloud_repository.iam_access_key_id
  sensitive   = true
}

output "cloud_repository_secret_access_key" {
  description = "Cloud Repository Secret Access Key for GitHub Actions"
  value       = module.s3_cloud_repository.iam_secret_access_key
  sensitive   = true
}

# Joker Cloud Repository 출력
output "joker_repository_bucket_name" {
  description = "Joker Cloud Repository S3 Bucket Name"
  value       = module.s3_joker_repository.bucket_name
}

output "joker_repository_bucket_arn" {
  description = "Joker Cloud Repository S3 Bucket ARN"
  value       = module.s3_joker_repository.bucket_arn
}

output "joker_repository_bucket_domain" {
  description = "Joker Cloud Repository S3 Bucket Domain Name"
  value       = module.s3_joker_repository.bucket_domain_name
}

output "joker_repository_bucket_regional_domain" {
  description = "Joker Cloud Repository S3 Bucket Regional Domain Name"
  value       = module.s3_joker_repository.bucket_regional_domain_name
}

# Map Editor Static Website Hosting 출력
output "map_editor_bucket_id" {
  description = "Map Editor S3 Bucket ID"
  value       = module.s3_map_editor.bucket_id
}

output "map_editor_bucket_arn" {
  description = "Map Editor S3 Bucket ARN"
  value       = module.s3_map_editor.bucket_arn
}

output "map_editor_bucket_name" {
  description = "Map Editor S3 Bucket Name"
  value       = module.s3_map_editor.bucket_name
}

output "map_editor_website_endpoint" {
  description = "Map Editor Website Endpoint"
  value       = module.s3_map_editor.website_endpoint
}

output "map_editor_website_url" {
  description = "Map Editor Website URL"
  value       = module.s3_map_editor.website_url
}

output "map_editor_iam_user_name" {
  description = "Map Editor IAM User Name for GitHub Actions"
  value       = module.s3_map_editor.iam_user_name
}

output "map_editor_access_key_id" {
  description = "Map Editor Access Key ID for GitHub Actions"
  value       = module.s3_map_editor.iam_access_key_id
  sensitive   = true
}

output "map_editor_secret_access_key" {
  description = "Map Editor Secret Access Key for GitHub Actions"
  value       = module.s3_map_editor.iam_secret_access_key
  sensitive   = true
}
