variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "environment" {
  description = "환경"
  type        = string
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "enabled" {
  description = "보안그룹 활성화 여부"
  type        = bool
  default     = true
} 