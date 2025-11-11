variable "project_name" {
  type        = string
  description = "Prefix for Lightsail resources"
}

variable "common_tags" {
  type        = map(string)
  description = "Common resource tags"
}

variable "availability_zone" {
  type        = string
  description = "AZ where Lightsail instance will be created"
  default     = "ap-south-1a"
}

variable "blueprint_id" {
  type        = string
  description = "Lightsail OS blueprint (e.g. amazon_linux_2, ubuntu_22_04)"
  default     = "amazon_linux_2"
}

variable "bundle_id" {
  type        = string
  description = "Instance size bundle (e.g. nano_2_0, micro_2_0)"
  default     = "nano_2_0"
}

