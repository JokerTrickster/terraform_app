# S3 버킷 생성
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = {
    Name        = var.bucket_name
    Environment = var.environment
    Project     = var.project_name
  }
}

# S3 버킷 버전 관리 설정
resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

# S3 버킷 서버 사이드 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# S3 버킷 공개 액세스 차단 설정 (이미지 공개 접근 허용)
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# S3 버킷 정책 - 공개 읽기 권한 부여
resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.main.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.main.arn}/*"
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.main]
}

# S3 버킷 소유권 제어
resource "aws_s3_bucket_ownership_controls" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# S3 버킷 ACL 설정
resource "aws_s3_bucket_acl" "main" {
  bucket = aws_s3_bucket.main.id
  acl    = "public-read"

  depends_on = [aws_s3_bucket_ownership_controls.main]
}

# 폴더 구조 생성 (S3는 실제로 폴더가 없지만, 키 접두사로 폴더 구조 시뮬레이션)
resource "aws_s3_object" "folders" {
  for_each = toset([
    "image/profile/",
    "image/daily/"
  ])

  bucket = aws_s3_bucket.main.id
  key    = each.value
  source = "/dev/null" # 빈 파일로 폴더 생성
}
