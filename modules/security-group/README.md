🔒 Security Group Module — Tanvora Infrastructure

📘 Overview

This Terraform module manages AWS Security Groups in a reusable and scalable way.
It allows you to define custom inbound (ingress) and outbound (egress) rules dynamically — supporting both CIDR-based and Security Group–based access control.

This module is designed for multi-tier architectures (e.g., Web, App, DB layers) following AWS and DevOps best practices.


⚙️ Resources Created
| Resource Type      | Terraform Resource                | Purpose                                                  |
| ------------------ | --------------------------------- | -------------------------------------------------------- |
| **Security Group** | `aws_security_group.this`         | Creates the base security group inside a VPC             |
| **Ingress Rules**  | `aws_security_group_rule.ingress` | Manages inbound traffic rules (port/protocol/source)     |
| **Egress Rules**   | `aws_security_group_rule.egress`  | Manages outbound traffic rules                           |
| **Tags**           | Inherited from `common_tags`      | Helps with identification, cost tracking, and automation |



🧩 Inputs (variables.tf)
| Variable        | Type           | Description                              | Example                         |
| --------------- | -------------- | ---------------------------------------- | ------------------------------- |
| `project_name`  | `string`       | Prefix for resource naming               | `"tanvora"`                     |
| `vpc_id`        | `string`       | ID of the VPC where SG will be created   | `module.vpc.vpc_id`             |
| `sg_name`       | `string`       | Logical name of the security group       | `"web"`, `"app"`, `"db"`        |
| `description`   | `string`       | Description for the security group       | `"Security group for web tier"` |
| `common_tags`   | `map(string)`  | Common tags applied to all resources     | `{ Environment = "prod" }`      |
| `ingress_rules` | `list(object)` | List of inbound rules (CIDR or SG based) | See examples below              |
| `egress_rules`  | `list(object)` | List of outbound rules                   | Defaults to allow all outbound  |


📤 Outputs (outputs.tf)
| Output              | Description                          |
| ------------------- | ------------------------------------ |
| `security_group_id` | The ID of the created security group |


🚀 Usage Examples

1️⃣ Web Security Group (Public)
Allows inbound HTTP/HTTPS from anywhere and SSH for management.

module "web_sg" {
  source       = "./modules/security-group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  sg_name      = "web"
  common_tags  = var.common_tags

  ingress_rules = [
    { from_port = 22, to_port = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "SSH access" },
    { from_port = 80, to_port = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "HTTP access" },
    { from_port = 443, to_port = 443, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "HTTPS access" }
  ]
}



2️⃣ App Security Group (Private)
Allows access only from Web SG, not from public internet.

module "app_sg" {
  source       = "./modules/security-group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  sg_name      = "app"
  common_tags  = var.common_tags

  ingress_rules = [
    {
      from_port                = 8080
      to_port                  = 8080
      protocol                 = "tcp"
      description              = "Allow from Web SG"
      source_security_group_id = module.web_sg.security_group_id
    }
  ]
}


3️⃣ Database Security Group (Private)
Allows inbound MySQL access only from the App SG.

module "db_sg" {
  source       = "./modules/security-group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  sg_name      = "db"
  common_tags  = var.common_tags

  ingress_rules = [
    {
      from_port                = 3306
      to_port                  = 3306
      protocol                 = "tcp"
      description              = "Allow MySQL from App SG"
      source_security_group_id = module.app_sg.security_group_id
    }
  ]
}


🧠 Design Philosophy

. Reusable: One flexible module for all security groups (web, app, db, etc.)
. Secure by Default: No inbound access unless explicitly defined
. Supports SG References: Enables private communication without public exposure
. Modular Integration: Works seamlessly with VPC, EC2, ALB, and RDS modules
. Consistent Tagging: All resources include common_tags for governance


✅ Verification Checklist
| Check         | Expected Result                     |
| ------------- | ----------------------------------- |
| SG created    | Appears under EC2 → Security Groups |
| Ingress rules | Match the defined inbound ports     |
| Egress rules  | Allow outbound as expected          |
| SG references | Linked correctly between modules    |
| Naming        | `tanvora-[tier]-sg` pattern         |
