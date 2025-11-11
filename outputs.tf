# Root outputs.tf


output "redis_primary_endpoint" {
  value = module.elasticache.redis_primary_endpoint
}

output "eks_cluster_name" {
  value = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.eks_cluster_endpoint
}


# output "rds_endpoint" {
#   description = "RDS database endpoint"
#   value       = module.rds.rds_endpoint
# }

# output "rds_sg_id" {
#   description = "RDS Security Group ID"
#   value       = module.rds.rds_sg_id
# }


# output "dynamodb_table_name" {
#   value       = module.dynamodb.table_name
#   description = "DynamoDB table name"
# }

# output "dynamodb_table_arn" {
#   value       = module.dynamodb.table_arn
#   description = "DynamoDB table ARN"
# }
