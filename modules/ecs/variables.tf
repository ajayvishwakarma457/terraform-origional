variable "project_name" {
  description = "Project name"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "image_uri" {
  description = "ECR image URI"
  type        = string
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 80
}

variable "private_subnets" {
  description = "Private subnet IDs for ECS tasks"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group for ECS tasks"
  type        = string
}
