variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}

variable "service_name" {
  description = "App Runner service name"
  type        = string
}

variable "image_uri" {
  description = "ECR image URI or Public ECR"
  type        = string
}

variable "port" {
  description = "Container port"
  type        = number
  default     = 3000
}

variable "environment" {
  description = "Environment variables for App Runner service"
  type        = map(string)
  default     = {}
}
