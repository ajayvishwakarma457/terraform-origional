output "eks_cluster_name" {
  value       = aws_eks_cluster.this.name
  description = "EKS Cluster Name"
}

output "eks_cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "EKS Cluster Endpoint"
}

output "eks_node_group_name" {
  value       = aws_eks_node_group.this.node_group_name
  description = "EKS Node Group Name"
}
