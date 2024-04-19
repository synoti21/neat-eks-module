data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, var.azs_count)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.1.2"

  name = "${var.eks_env}-vpc"

  cidr = var.vpc_cidr
  azs  = local.azs

  private_subnets = [for k,v in local.azs: cidrsubnet(var.vpc_cidr, 4, k+1)]
  public_subnets  = [for k,v in local.azs: cidrsubnet(var.vpc_cidr, 4, k+4)]

  enable_nat_gateway   = var.enable_nat_gateway
  single_nat_gateway   = var.single_nat_gateway
  enable_dns_hostnames = var.enable_dns_hostnames

  public_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_env}-eks" = "shared"
    "kubernetes.io/role/elb"                      = 1
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${var.eks_env}-eks" = "shared"
    "kubernetes.io/role/internal-elb"             = 1
  }
}