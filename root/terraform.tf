terraform {

  backend "s3" {
    bucket = "synoti21-eks"
    key    = "eks/root"
    region = "ap-northeast-2"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  required_version = "~> 1.3"
}