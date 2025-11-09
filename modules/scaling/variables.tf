variable "project_name" { type = string }
variable "common_tags"  { type = map(string) }

variable "vpc_id" { type = string }
variable "public_subnet_ids" { type = list(string) }
variable "private_subnet_ids" { type = list(string) }

# Security Group IDs (from security-group module)
variable "alb_sg_id" {
  description = "ALB Security Group ID"
  type        = string
}

variable "app_sg_id" {
  description = "App Security Group ID"
  type        = string
}

# Compute
variable "instance_type" { 
    type = string
    default = "t3.micro" 
}
variable "ami_id"        { 
    type = string
    default = "" 
}
variable "iam_instance_profile_name" { type = string }

# Scaling
variable "desired_capacity" { 
    type = number
    default = 2 
}

variable "min_size"         { 
    type = number 
    default = 2 
}

variable "max_size"  { 
    type = number
    default = 4 
}

# App
variable "user_data" { 
    type = string
    default = "" 
}
variable "health_check_path" { 
    type = string
    default = "/" 
}

# SSL
variable "alb_certificate_arn" { 
    description = "ACM certificate ARN"
    type = string 
}
