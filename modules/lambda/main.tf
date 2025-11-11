##################################################
# IAM Role for Lambda
##################################################
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-lambda-role"
  })
}

resource "aws_iam_role_policy_attachment" "lambda_basic_execution" {
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

# Optional – attach this if your Lambda interacts with VPC resources
resource "aws_iam_role_policy_attachment" "vpc_access" {
  count      = var.enable_vpc ? 1 : 0
  role       = aws_iam_role.lambda_exec_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaVPCAccessExecutionRole"
}

##################################################
# Lambda Function
##################################################
resource "aws_lambda_function" "this" {
  function_name = "${var.project_name}-lambda"
  role          = aws_iam_role.lambda_exec_role.arn
  handler       = var.handler
  runtime       = var.runtime
  filename      = var.filename

  source_code_hash = filebase64sha256(var.filename)

  environment {
    variables = var.environment
  }

  timeout = 10
  memory_size = 128

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-lambda"
  })
}

##################################################
# Optional VPC Configuration
##################################################
resource "aws_lambda_function_event_invoke_config" "this" {
  function_name = aws_lambda_function.this.function_name

  maximum_retry_attempts      = 2
  maximum_event_age_in_seconds = 60
}
