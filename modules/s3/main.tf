# S3 버킷 생성
resource "aws_s3_bucket" "main" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
    Environment = var.environment
  }
}

# 백엔드용 S3 버킷 생성
resource "aws_s3_bucket" "backend" {
  bucket = "board-game-app-terraform-backend-${var.environment}"

  tags = {
    Name = "board-game-app-terraform-backend-${var.environment}"
    Environment = var.environment
    Purpose = "Terraform Backend"
  }
}

# 백엔드 버킷 버전 관리 설정
resource "aws_s3_bucket_versioning" "backend" {
  bucket = aws_s3_bucket.backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

# 백엔드 버킷 서버 사이드 암호화 설정
resource "aws_s3_bucket_server_side_encryption_configuration" "backend" {
  bucket = aws_s3_bucket.backend.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# 백엔드 버킷 공개 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "backend" {
  bucket = aws_s3_bucket.backend.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
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

# S3 버킷 공개 액세스 차단 설정
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# 폴더 구조 생성 (S3는 실제로 폴더가 없지만, 키 접두사로 폴더 구조 시뮬레이션)
resource "aws_s3_object" "folders" {
  for_each = toset([
    "profiles/",
    "cards/",
    "frog/images/",
    "find-it/images/",
    "board_game/images/",
    "wingspan/missions/",
    "wingspan/images/",
    "slime_war/images/"
  ])

  bucket = aws_s3_bucket.main.id
  key    = each.value
  source = "/dev/null"  # 빈 파일로 폴더 생성
} 