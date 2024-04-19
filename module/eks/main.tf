provider "aws" {
  region = var.region
}

data "aws_availability_zones" "available" {}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "19.17.2"

  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids

  cluster_name    = "${var.eks_env}-eks"
  cluster_version = var.eks_version
  cluster_service_ipv4_cidr = var.cluster_service_ipv4_cidr
  cluster_endpoint_public_access = var.cluster_endpoint_public_access

  cluster_addons = local.cluster_addons

  eks_managed_node_group_defaults = {
    ami_type = var.node_group_ami_type
  }

  eks_managed_node_groups = var.eks_managed_node_groups
}

# eks cluster node security group update
resource "aws_security_group_rule" "eks_node_security_group_rule" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 65535
  protocol                 = "tcp"
  source_security_group_id = module.eks.node_security_group_id
  security_group_id        = module.eks.node_security_group_id
  description              = "Allow communication between worker nodes"
}
