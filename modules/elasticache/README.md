⚡ ElastiCache (Redis) Module — Tanvora Infrastructure

📘 Overview

This Terraform module provisions a fully managed, multi-AZ Redis ElastiCache cluster on AWS.
It automatically sets up the subnet group, security group, and replication group required for a reliable, fault-tolerant Redis setup used by your applications within private subnets.

This implementation follows AWS best practices — private network isolation, multi-AZ redundancy, and automatic failover for high availability.


⚙️ Resources Created
| Resource Type         | Terraform Resource                                        | Purpose                                                                  |
| --------------------- | --------------------------------------------------------- | ------------------------------------------------------------------------ |
| **Subnet Group**      | `aws_elasticache_subnet_group.tanvora_cache_subnet_group` | Defines private subnets used by the Redis cluster                        |
| **Security Group**    | `aws_security_group.tanvora_cache_sg`                     | Restricts Redis access to private subnets only                           |
| **Replication Group** | `aws_elasticache_replication_group.tanvora_redis`         | Creates the Redis cluster (multi-AZ, auto failover, replication enabled) |


🧩 Inputs (variables.tf)
| Variable              | Type           | Description                               | Example / Default               |
| --------------------- | -------------- | ----------------------------------------- | ------------------------------- |
| `project_name`        | `string`       | Project prefix for resource naming        | `"tanvora"`                     |
| `common_tags`         | `map(string)`  | Common tags for resource tracking         | `{ Environment = "prod" }`      |
| `vpc_id`              | `string`       | VPC ID where Redis will be deployed       | `module.vpc.vpc_id`             |
| `private_subnet_ids`  | `list(string)` | Private subnet IDs for Redis subnet group | `module.vpc.private_subnet_ids` |
| `private_cidr_blocks` | `list(string)` | CIDR blocks allowed to access Redis       | `var.private_subnet_cidrs`      |
| `node_type`           | `string`       | Redis instance type                       | `"cache.t3.micro"`              |
| `num_nodes`           | `number`       | Number of Redis cache nodes               | `2`                             |


📤 Outputs (outputs.tf)
| Output                   | Description                                         |
| ------------------------ | --------------------------------------------------- |
| `redis_primary_endpoint` | Primary Redis endpoint for application connection   |
| `redis_sg_id`            | Security group ID associated with the Redis cluster |


🚀 Usage Example (Root Module)
In your root main.tf:

module "elasticache" {
  source             = "./modules/elasticache"
  project_name       = var.project_name
  common_tags        = var.common_tags
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  private_cidr_blocks = var.private_subnet_cidrs
}



🧠 Design Notes

🔐 Network Isolation
. Redis is deployed inside private subnets, never publicly accessible.
. Access is controlled via the ElastiCache Security Group, which allows only private CIDR ranges defined by private_cidr_blocks.

🧩 High Availability
. Uses multi-AZ replication (multi_az_enabled = true) and automatic failover for resilience.
. Multiple nodes (num_nodes) ensure Redis remains operational even during AZ failures.

⚙️ Scalability & Maintenance
. Configurable instance type (node_type) and node count (num_nodes) for scaling.
. Version-locked Redis engine (7.1) ensures compatibility and stability.

🏷️ Tagging & Naming
. All resources use common_tags for consistent tagging (cost management, environment tracking).
. Resource names follow the convention:
    . ${project_name}-cache-sg
    . ${project_name}-cache-subnet-group
    . ${project_name}-redis


✅ Verification Checklist
| Check             | Expected Result                                  |
| ----------------- | ------------------------------------------------ |
| Subnet Group      | Created with private subnets                     |
| Security Group    | Allows port `6379` only from private CIDRs       |
| Replication Group | Redis cluster active across multiple AZs         |
| Primary Endpoint  | Accessible within VPC private network            |
| Tags              | Match project and environment naming conventions |


🧾 Summary
This module provisions a secure, highly available Redis ElastiCache cluster for internal application caching.

It ensures:
. Encrypted private communication
. Multi-AZ fault tolerance
. Auto failover and version-controlled Redis
. Reusable configuration for any environment (dev, staging, prod)