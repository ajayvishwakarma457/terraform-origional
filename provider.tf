terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket         = "tanvora-terraform-state-001"
    key            = "infra/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "tanvora-terraform-lock"
    encrypt        = true
  }

}

# Main AWS provider (your primary region)
provider "aws" {
  region = var.aws_region
}

# Secondary provider for ACM (required by CloudFront → must be us-east-1)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}
