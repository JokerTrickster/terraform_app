# S3 Bucket for static website hosting
resource "aws_s3_bucket" "workflow_hosting" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = var.project_name
  }
}

# S3 Bucket Website Configuration
resource "aws_s3_bucket_website_configuration" "workflow_hosting" {
  bucket = aws_s3_bucket.workflow_hosting.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html" # SPA routing support
  }
}

# S3 Bucket Public Access Block Settings
resource "aws_s3_bucket_public_access_block" "workflow_hosting" {
  bucket = aws_s3_bucket.workflow_hosting.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 Bucket Policy for Public Read Access
resource "aws_s3_bucket_policy" "workflow_hosting" {
  bucket = aws_s3_bucket.workflow_hosting.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.workflow_hosting.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.workflow_hosting]
}
