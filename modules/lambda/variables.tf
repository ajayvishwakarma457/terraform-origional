variable "project_name" {
  description = "Project name prefix"
  type        = string
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "runtime" {
  description = "Runtime for the Lambda function (e.g. python3.11, nodejs18.x)"
  type        = string
  default     = "python3.11"
}

variable "handler" {
  description = "Lambda function entry point"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "filename" {
  description = "Path to the deployment package ZIP file"
  type        = string
}

variable "environment" {
  description = "Environment variables for the Lambda function"
  type        = map(string)
  default     = {}
}

variable "enable_vpc" {
  description = "Whether to attach VPC permissions"
  type        = bool
  default     = false
}
