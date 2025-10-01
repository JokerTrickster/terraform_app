output "cloudfront_url" {
  description = "CloudFront distribution domain name"
  value       = "https://${aws_cloudfront_distribution.workflow_hosting.domain_name}"
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for cache invalidation"
  value       = aws_cloudfront_distribution.workflow_hosting.id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name (without https://)"
  value       = aws_cloudfront_distribution.workflow_hosting.domain_name
}

output "s3_bucket_name" {
  description = "S3 bucket name for deployment"
  value       = aws_s3_bucket.workflow_hosting.id
}

output "s3_bucket_arn" {
  description = "S3 bucket ARN"
  value       = aws_s3_bucket.workflow_hosting.arn
}

output "s3_website_endpoint" {
  description = "S3 website endpoint"
  value       = aws_s3_bucket_website_configuration.workflow_hosting.website_endpoint
}

output "iam_user_name" {
  description = "IAM user name for GitHub Actions"
  value       = aws_iam_user.github_actions_deploy.name
}

output "iam_user_arn" {
  description = "IAM user ARN"
  value       = aws_iam_user.github_actions_deploy.arn
}
