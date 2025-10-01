variable "bucket_name" {
  description = "S3 bucket name for static website hosting"
  type        = string
  default     = "jokertrickster-workflow"
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
  default     = "prod"
}

variable "project_name" {
  description = "Project name for resource tagging"
  type        = string
  default     = "workflow"
}
