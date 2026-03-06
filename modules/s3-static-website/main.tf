# S3 버킷 생성 (Static Website Hosting)
resource "aws_s3_bucket" "website" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Purpose     = "Static Website Hosting"
  }
}

# S3 버킷 웹사이트 설정
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

# S3 버킷 공개 액세스 허용 설정
resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 버킷 정책 - 공개 읽기 권한
resource "aws_s3_bucket_policy" "website" {
  bucket = aws_s3_bucket.website.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.website]
}

# S3 버킷 CORS 설정 (필요시)
resource "aws_s3_bucket_cors_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "HEAD"]
    allowed_origins = ["*"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

# GitHub Actions 용 IAM 사용자 생성
resource "aws_iam_user" "github_actions" {
  name = "${var.bucket_name}-github-actions"

  tags = {
    Name        = "${var.bucket_name}-github-actions"
    Environment = var.environment
    Purpose     = "GitHub Actions for S3 deployment"
  }
}

# IAM 사용자 액세스 키
resource "aws_iam_access_key" "github_actions" {
  user = aws_iam_user.github_actions.name
}

# IAM 정책 - S3 버킷 접근 권한
resource "aws_iam_user_policy" "github_actions" {
  name = "${var.bucket_name}-github-actions-policy"
  user = aws_iam_user.github_actions.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:ListBucket",
          "s3:GetBucketLocation"
        ]
        Resource = aws_s3_bucket.website.arn
      },
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:PutObjectAcl"
        ]
        Resource = "${aws_s3_bucket.website.arn}/*"
      }
    ]
  })
}
