
module "vpc" {
  source = "./modules/vpc"

  project_name         = var.project_name
  aws_region           = var.aws_region
  common_tags          = var.common_tags
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  common_tags  = var.common_tags
}

# # ------------------------------------
# # SECURITY GROUPS (Reusable Modules)
# # ------------------------------------

# # ALB Security Group
module "alb_sg" {
  source       = "./modules/security-group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  sg_name      = "alb-sg"
  common_tags  = var.common_tags
  description  = "Security group for Application Load Balancer"

  ingress_rules = [
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    }
  ]
}

# APP Security Group
module "app_sg" {
  source       = "./modules/security-group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  sg_name      = "app-sg"
  common_tags  = var.common_tags
  description  = "Security group for App instances"

  ingress_rules = [
    {
      from_port       = 80
      to_port         = 80
      protocol        = "tcp"
      cidr_blocks     = ["0.0.0.0/0"] # or restrict to ALB SG later
      description     = "Allow HTTP from ALB"
    }
  ]
}

# # WEB Security Group
module "web_sg" {
  source       = "./modules/security-group"
  project_name = var.project_name
  vpc_id       = module.vpc.vpc_id
  sg_name      = "web-sg"
  common_tags  = var.common_tags
  description  = "Security group for web servers"

  ingress_rules = [
    {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "SSH access"
    },
    {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTP access"
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      description = "HTTPS access"
    }
  ]
}

module "elasticache" {
  source             = "./modules/elasticache"
  project_name       = var.project_name
  common_tags        = var.common_tags
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  # private_cidr_blocks = [var.private_subnet_cidr_a, var.private_subnet_cidr_b]
  private_cidr_blocks = var.private_subnet_cidrs
}

module "dynamodb" {
  source       = "./modules/dynamodb"
  project_name = var.project_name
  common_tags  = var.common_tags

  table_name    = "tanvora-users"
  hash_key      = "userId"
  hash_key_type = "S"
  sort_key      = "createdAt"
  sort_key_type = "S"
}

module "cloudfront" {
  source       = "./modules/cloudfront"
  project_name = var.project_name
  aws_region   = var.aws_region
  common_tags  = var.common_tags

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  # Optional overrides
  # bucket_name = "tanvora-cdn-static"
  # domain_name = "cdn.tanvora.com"
  # alternate_names = ["static.tanvora.com"]
  # route53_zone_id = "Z123456ABCDEFG"
}

# MACHINE IN PRIVATE SUBNET
module "ec2" {
  source             = "./modules/ec2"
  project_name       = var.project_name
  common_tags        = var.common_tags
  vpc_id             = module.vpc.vpc_id
  vpc_cidr           = var.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids
  ec2_role_name      = module.iam.ec2_role_name
}



