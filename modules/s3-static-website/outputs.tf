output "bucket_id" {
  description = "ID of the S3 bucket"
  value       = aws_s3_bucket.website.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.website.arn
}

output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.website.bucket
}

output "website_endpoint" {
  description = "Website endpoint URL"
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "website_domain" {
  description = "Website domain (bucket regional domain)"
  value       = aws_s3_bucket.website.bucket_regional_domain_name
}

output "website_url" {
  description = "Full website URL"
  value       = "http://${aws_s3_bucket_website_configuration.website.website_endpoint}"
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
