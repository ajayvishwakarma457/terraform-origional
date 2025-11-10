output "security_group_id" {
  value       = aws_security_group.this.id
  description = "The ID of the created security group"
}

output "alb_sg_id" {
  description = "Security Group ID for the ALB"
  value       = aws_security_group.this.id
}

output "app_sg_id" {
  description = "Security Group ID for the application instances"
  value       = aws_security_group.this.id
}

