output "bucket_id" {
  description = "The ID of the S3 bucket"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "The ARN of the S3 bucket"
  value       = aws_s3_bucket.main.arn
}

output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket
}

output "website_endpoint" {
  description = "The website endpoint of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.main.website_endpoint
}

output "website_domain" {
  description = "The website domain of the S3 bucket"
  value       = aws_s3_bucket_website_configuration.main.website_domain
}

output "bucket_regional_domain_name" {
  description = "The regional domain name of the S3 bucket"
  value       = aws_s3_bucket.main.bucket_regional_domain_name
}

output "iam_user_name" {
  description = "The name of the IAM user for GitHub Actions"
  value       = aws_iam_user.github_actions.name
}

output "iam_access_key_id" {
  description = "The access key ID for GitHub Actions"
  value       = aws_iam_access_key.github_actions.id
  sensitive   = true
}

output "iam_secret_access_key" {
  description = "The secret access key for GitHub Actions"
  value       = aws_iam_access_key.github_actions.secret
  sensitive   = true
}
