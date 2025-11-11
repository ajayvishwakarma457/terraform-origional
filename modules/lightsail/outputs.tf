output "lightsail_instance_name" {
  value       = aws_lightsail_instance.this.name
  description = "Lightsail instance name"
}

output "lightsail_public_ip" {
  value       = aws_lightsail_static_ip.this.ip_address
  description = "Public IP assigned to the Lightsail instance"
}
