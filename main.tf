
module "acm" {
  source          = "./modules/acm"
  aws_region      = var.aws_region
  project_name    = var.project_name
  domain_name     = var.domain_name
  route53_zone_id = module.route53.route53_zone_id
  common_tags     = var.common_tags
}

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

module "scaling" {
  source = "./modules/scaling"

  project_name       = var.project_name
  common_tags        = var.common_tags
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  instance_type              = "t3.micro"
  iam_instance_profile_name   = "${var.project_name}-ec2-profile"

  desired_capacity = 2
  min_size         = 2
  max_size         = 4

  health_check_path  = "/"
  alb_certificate_arn = module.acm.alb_cert_arn

  # 👇 Add these two lines
  alb_sg_id = module.web_sg.security_group_id
  app_sg_id = module.app_sg.security_group_id
}

module "route53" {
  source       = "./modules/route53"
  project_name = var.project_name
  domain_name  = "spakcommgroup.com"
  common_tags  = var.common_tags

  alb_dns_name = module.scaling.alb_dns_name
  alb_zone_id  = module.scaling.alb_zone_id

  cloudfront_domain_name    = module.cloudfront.cloudfront_domain_name
  cloudfront_hosted_zone_id = "Z2FDTNDATAQYW2" # always same for CloudFront globally

  # Optional: if you also have api subdomain
  create_api_record = true
  api_dns_name      = module.scaling.alb_dns_name
  api_zone_id       = module.scaling.alb_zone_id
}

module "lightsail" {
  source            = "./modules/lightsail"
  project_name      = var.project_name
  common_tags       = var.common_tags
  availability_zone = "ap-south-1a"
  blueprint_id      = "ubuntu_22_04"
  bundle_id         = "micro_3_1"
}

module "ecr" {
  source       = "./modules/ecr"
  project_name = var.project_name
  common_tags  = var.common_tags
}

# module "apprunner" {
#   source       = "./modules/apprunner"
#   project_name = var.project_name
#   common_tags  = var.common_tags
#   service_name = "tanvora-apprunner"
#   image_uri    = "${module.ecr.repository_url}:latest"  # uses the ECR module output
#   port         = 3000
#   environment  = {
#     NODE_ENV = "production"
#   }
# }





