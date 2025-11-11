resource "random_string" "suffix" {
  length  = 4
  special = false
}


##############################################
# AWS App Runner Service
##############################################

resource "aws_iam_role" "apprunner_role" {
  # name = "${var.project_name}-apprunner-role"
   name = "${var.project_name}-apprunner-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = {
        Service = "build.apprunner.amazonaws.com"
      }
    }]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-apprunner-role"
  })
}

resource "aws_apprunner_service" "this" {
  service_name = var.service_name

  source_configuration {
    image_repository {
      image_configuration {
        port = var.port
        runtime_environment_variables = var.environment
      }

      image_identifier      = var.image_uri
      image_repository_type = "ECR"
    }

    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_role.arn
    }
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-apprunner"
  })
}

##############################################
# Auto-scaling configuration
##############################################
resource "aws_apprunner_auto_scaling_configuration_version" "this" {
  auto_scaling_configuration_name = "${var.project_name}-auto-scaling"

  max_concurrency = 50
  max_size        = 5
  min_size        = 1

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-apprunner-scaling"
  })
}
