terraform {
  required_version = ">= 1.0"
  
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

   backend "s3" {
     bucket = "board-game-app-terraform-backend-dev"
     key    = "terraform.tfstate"
     region = "ap-south-1"
   }
}

provider "aws" {
  region = var.aws_region
} 