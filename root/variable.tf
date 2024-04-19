variable "vpc_cidr" {
  type = string
  description = "VPC의 CIDR 블록 (IP 대역 범위)"
  default = "10.12.0.0/16"
}

variable "azs_count" {
  type = number
  description = "VPC에서 가용할 Availability Zone의 개수"
  default = 3
}

variable "enable_nat_gateway" {
  type = bool
  description = "Nat Gateway 생성 여부"
  default = true
}

variable "single_nat_gateway" {
  type = bool
  description = "VPC에 단 하나의 NAT Gateway만 설치할 것인지의 여부. (False시 서브넷 별로 NAT Gateway 생성)"
  default = true
}

variable "enable_dns_hostnames" {
  type = bool
  description = "VPC의 DNS hostname을 생성할 것인지의 여부"
  default = true
}

variable "eks_env" {
  type = string
  description = "EKS가 배포될 환경의 이름 (ex. dev, qa, prod 등)"
  default = "test_tf"
}

variable "region" {
  type = string
  description = "EKS가 배포될 AWS 리전"
  default = "ap-northeast-2"
}

variable "eks_version" {
  type = string
  description = "배포할 EKS의 Kubernetes 버전 (ex. 1.29)"
  default = "1.29"
}

variable "cluster_endpoint_public_access" {
  type = bool
  description = "EKS Cluster에 Public하게 접근할 수 있는 Endpoint 제공 여부"
  default = true
}

variable "cluster_service_ipv4_cidr" {
  type = string
  description = "Kubernetes 내부의 service 리소스가 사용할 IP 대역"
}

variable "eks_addon_version" {
  type = map(string)
  description = "EKS에 설치할 add-on의 version"
  default = {
    aws_ebs_csi_driver = "v1.29.1-eksbuild.1"
  } 
}