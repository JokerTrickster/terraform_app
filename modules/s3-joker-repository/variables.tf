variable "bucket_name" {
  description = "S3 버킷 이름"
  type        = string
  default     = "joker-cloud-repository"
}

variable "environment" {
  description = "환경 구분 (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
  default     = "joker-cloud"
}