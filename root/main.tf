module "vpc" {
  source = "../module/vpc"
  vpc_cidr = var.vpc_cidr
  azs_count = var.azs_count

  eks_env = var.eks_env

  enable_nat_gateway = var.enable_nat_gateway
  single_nat_gateway = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames
}

module "s3_gateway_endpoint" {
    source = "../module/s3_gateway"
    vpc_name = "${var.eks_env}-vpc"
}

module "dynamoDB_gateway_endpoint" {
    source = "../module/dynamoDB_gateway"
    vpc_name = "${var.eks_env}-vpc"
}

module "vpc-peering" {
  source = "../module/vpc-peering"
  requester_name = "${var.eks_env}"
  requester_vpc_id = module.vpc.vpc_id
  region = var.region
}

module "eks" {
  source = "../module/eks"
  vpc_id = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  eks_env = var.eks_env
  eks_version = var.eks_version

  eks_managed_node_groups = local.eks_managed_node_groups
  
  cluster_endpoint_public_access = var.cluster_endpoint_public_access
  cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr
}

