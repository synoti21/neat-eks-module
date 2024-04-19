output "vpc_id" {
  description = "My VPC id"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "Public subnet 리스트"
  value       = module.vpc.public_subnets
}

output "private_subnets" {
  description = "Private subnet 리스트"
  value       = module.vpc.private_subnets
}

output "vpc_cidr_block" {
  description = "VPC의 CIDR 블럭 값"
  value       = module.vpc.vpc_cidr_block
}

output "public_route_table_ids" {
  description = "VPC의 Public Route Table ID 리스트"
  value       = module.vpc.public_route_table_ids
}

output "private_route_table_ids" {
  description = "VPC의 Private Route Table ID 리스트"
  value       = module.vpc.private_route_table_ids
}

output "nat_public_ips" {
  description = "AWS NAT Gateway에 배정된 Elastic IP"
  value       = formatlist("%s/32", module.vpc.nat_public_ips)
}