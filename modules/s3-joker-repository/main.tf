# S3 버킷 생성 - 유저 업로드용 스토리지
resource "aws_s3_bucket" "main" {
  bucket = "${var.bucket_name}-${var.environment}"

  tags = {
    Name        = "${var.bucket_name}-${var.environment}"
    Environment = var.environment
    Project     = var.project_name
    Purpose     = "User uploaded media storage"
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

# S3 버킷 공개 액세스 차단 설정 (presigned URL은 허용)
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = false # Presigned URL 정책 허용
  ignore_public_acls      = true
  restrict_public_buckets = false # Presigned URL 접근 허용
}

# CORS 설정 - Presigned URL 업로드를 위한 설정
resource "aws_s3_bucket_cors_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST", "HEAD", "DELETE"]
    allowed_origins = ["*"] # 프로덕션에서는 특정 도메인으로 제한 권장
    expose_headers = [
      "ETag",
      "x-amz-server-side-encryption",
      "x-amz-request-id",
      "x-amz-id-2"
    ]
    max_age_seconds = 3000
  }
}

# S3 버킷 정책 - Presigned URL 사용을 위해 필요한 경우에만 적용
# 현재는 비워두고, presigned URL은 IAM 정책으로 처리

# 폴더 구조 생성 (이미지 및 동영상 분류용)
resource "aws_s3_object" "folders" {
  for_each = toset([
    "images/",
    "videos/",
    "documents/",
    "temp/" # 임시 업로드용
  ])

  bucket = aws_s3_bucket.main.id
  key    = each.value
  source = "/dev/null"
}

# Lifecycle 규칙 - 임시 파일 자동 삭제
resource "aws_s3_bucket_lifecycle_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    id     = "delete-temp-files"
    status = "Enabled"

    filter {
      prefix = "temp/"
    }

    expiration {
      days = 7 # temp 폴더의 파일은 7일 후 자동 삭제
    }
  }

  rule {
    id     = "delete-old-versions"
    status = "Enabled"

    filter {} # 모든 객체에 적용

    noncurrent_version_expiration {
      noncurrent_days = 30 # 이전 버전은 30일 후 삭제
    }
  }

  rule {
    id     = "abort-incomplete-multipart-uploads"
    status = "Enabled"

    filter {} # 모든 객체에 적용

    abort_incomplete_multipart_upload {
      days_after_initiation = 1 # 미완성 멀티파트 업로드는 1일 후 삭제
    }
  }
}