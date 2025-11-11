resource "random_string" "suffix" {
  length  = 4
  special = false
}

##############################################
# IAM Role for App Runner
##############################################
resource "aws_iam_role" "apprunner_role" {
  name = "${var.project_name}-apprunner-role-${random_string.suffix.result}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Principal = {
          Service = [
            "build.apprunner.amazonaws.com",
            "tasks.apprunner.amazonaws.com"
          ]
        }
      }
    ]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-apprunner-role"
  })
}

##############################################
# IAM Policy for ECR Access
##############################################
resource "aws_iam_role_policy" "ecr_access" {
  role = aws_iam_role.apprunner_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
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

##############################################
# App Runner Service
##############################################
resource "aws_apprunner_service" "this" {
  service_name = var.service_name

  source_configuration {
    image_repository {
      image_identifier      = var.image_uri
      image_repository_type = "ECR"

      image_configuration {
        port                        = var.port
        runtime_environment_variables = var.environment
      }
    }

    authentication_configuration {
      access_role_arn = aws_iam_role.apprunner_role.arn
    }

    auto_deployments_enabled = false
  }

  instance_configuration {
    cpu    = "1024"
    memory = "2048"
  }

  auto_scaling_configuration_arn = aws_apprunner_auto_scaling_configuration_version.this.arn

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-apprunner"
  })
}
