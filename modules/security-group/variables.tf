variable "project_name" {
  description = "Project prefix for resource naming"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID to associate with this Security Group"
  type        = string
}

variable "sg_name" {
  description = "Name of the Security Group (e.g. web-sg, db-sg)"
  type        = string
}

variable "description" {
  description = "Description for the Security Group"
  type        = string
  default     = "Managed by Terraform"
}

variable "common_tags" {
  description = "Common tags for all resources"
  type        = map(string)
}

variable "ingress_rules" {
  description = "List of ingress (inbound) rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
}

variable "egress_rules" {
  description = "List of egress (outbound) rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = optional(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = ["0.0.0.0/0"]
      description = "Allow all outbound traffic"
    }
  ]
}
