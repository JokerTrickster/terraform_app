variable "environment" {
  description = "환경"
  type        = string
}

variable "project_name" {
  description = "프로젝트 이름"
  type        = string
}

variable "enabled" {
  description = "IAM 리소스 활성화 여부"
  type        = bool
  default     = true
} 