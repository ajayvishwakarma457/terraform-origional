variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS cluster and node group"
  type        = list(string)
}
