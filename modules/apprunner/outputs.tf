output "apprunner_service_url" {
  value = aws_apprunner_service.this.service_url
}

output "apprunner_role_arn" {
  value = aws_iam_role.apprunner_role.arn
}
