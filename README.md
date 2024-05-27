# Neat EKS Module
![Repository License](https://img.shields.io/github/license/synoti21/neat-eks-module)
[![Hits](https://hits.seeyoufarm.com/api/count/incr/badge.svg?url=https%3A%2F%2Fgithub.com%2Fsynoti21%2Fneat-eks-module&count_bg=%238D3DC8&title_bg=%23555555&icon=&icon_color=%23E7E7E7&title=hits&edge_flat=false)](https://hits.seeyoufarm.com)

## Usage
Change the value of `root/setting.tfvars` to customize:
```
vpc_cidr = "10.0.0.0/16"
azs_count = 3

enable_nat_gateway = true
...
```

To customize the EKS node group, modify the `/root/locals.tf`:
```
locals {
    eks_managed_node_groups = {
        first = {
            name = "${var.eks_env}-node-group-1"
            instance_types = ["t3.large"] # modify this

            min_size     = 1 # modify this
            max_size     = 3 # modify this
            desired_size = 1 # modify this

            cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
            vpc_security_group_ids            = [module.eks.node_security_group_id]
        }
    }
}
```
Following fields are customizable:
- `instance_types`: Spec of the node (EC2)
- `min_size`: Minimum node count
- `max_size`: Maximum node count
- `desired_size`: Desired node count that will be maintained in default state.

Modifying other fields are not recommended.

After customizing, modify the `root/terraform.tf` to save state in your S3 Bucket.
```
terraform {
  backend "s3" {
    bucket = "synoti21-eks" # Your Bucket
    key    = "eks/root" # Key in your Bucket
    region = "ap-northeast-2" # Region of your Bucket
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.3"
}
```
You should set your context to your AWS account, to grant Terraform to access your S3.

For example, set the context by using AWS CLI.
```
aws configure
```

Finally, run the following command:
```
cd root
terraform init
terraform apply -var-file="settings.tfvars"
```

The following resources will be created:
- VPC
- VPC Endpoint (S3, DynamoDB Gateway)
- VPC Peering (optional)
- EKS

