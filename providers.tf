terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  # S3 백엔드 설정
  backend "s3" {
    bucket = "terraform-app-terraform-backend-dev"
    key    = "terraform.tfstate"
    region = "ap-northeast-2"
    
    # DynamoDB를 사용한 상태 잠금 (선택사항)
    # dynamodb_table = "terraform-locks"
    # encrypt = true
  }
}

provider "aws" {
  region = var.aws_region
} 