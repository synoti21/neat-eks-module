output "cluster_endpoint" {
  description = "EKS Control Plane의 Endpoint"
  value       = module.eks.cluster_endpoint
}

output "cluster_security_group_id" {
  description = "EKS Cluster Control Plane에 attach된 Security Group ID"
  value       = module.eks.cluster_security_group_id
}

output "cluster_id" {
  description = "EKS Cluster의 ID"
  value       = module.eks.cluster_id
}

output "cluster_oidc_issuer_url" {
  description = "EKS Cluster의 OIDC Issuer URL"
  value       = module.eks.cluster_oidc_issuer_url
}

output "cluster_primary_security_group_id" {
  description = "EKS Console 내 Cluster Security Group에 해당."
  value       = module.eks.cluster_primary_security_group_id
}

output "node_security_group_id" {
  description = "EKS Console 내 Cluster Security Group에 해당."
  value       = module.eks.node_security_group_id
}

output "oidc_provider_arn" {
  description = "EKS Cluster OIDC Provider의 ARN"
  value       = module.eks.oidc_provider_arn
}

output "oidc_provider" {
  description = "EKS Cluster의 OIDC Provider"
  value       = module.eks.oidc_provider
}