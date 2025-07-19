terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"  # 6.x 버전으로 변경
    }
  }
}

provider "aws" {
  region = "ap-south-1"
} 