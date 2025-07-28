output "bucket_id" {
  description = "S3 버킷 ID"
  value       = aws_s3_bucket.main.id
}

output "bucket_arn" {
  description = "S3 버킷 ARN"
  value       = aws_s3_bucket.main.arn
}

output "bucket_name" {
  description = "S3 버킷 이름"
  value       = aws_s3_bucket.main.bucket
}

output "backend_bucket_id" {
  description = "백엔드 S3 버킷 ID"
  value       = aws_s3_bucket.backend.id
}

output "backend_bucket_name" {
  description = "백엔드 S3 버킷 이름"
  value       = aws_s3_bucket.backend.bucket
} 