variable "project_name" {
  description = "Name prefix for ECR"
  type        = string
}

variable "common_tags" {
  description = "Common tags for resources"
  type        = map(string)
}
