#### VPC
# CIDR of VPC. Automatically Slices for subnets
vpc_cidr = "10.0.0.0/16"
# Count of availability zones (ex. 3 => az-a, az-b, az-c)
azs_count = 3

### NAT Gateway
# If enabled, default NAT Gateway will be created in public subnet
enable_nat_gateway = true
# If enabled, NAT Gateway will be created once
single_nat_gateway = true
# If enabled, DNS hostnames in the VPC will be enabled
enable_dns_hostnames = true

### VPC Peering
# To create vpc peering, enable this.
enable_vpc_peering = false
# Type the VPC you want to peer with
peering_accepter_vpc = "default"

### EKS
# Environment of EKS Cluster. The name will be ${eks_env}-eks.
eks_env = "default"
# Region of your EKS to be created
region = "ap-northeast-2"
# Kubernetes version of your EKS
eks_version = "1.29"
# EKS public API Server Endpoint 
cluster_endpoint_public_access = false

### Addon
# To attach addon, type the name of addon and its version.
eks_addon_version = {
  aws_ebs_csi_driver = "v1.29.1-eksbuild.1"
}