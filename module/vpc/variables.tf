variable "eks_env" {
  type = string
  description = "EKS가 배포될 환경"
  default = "dev"
}

variable "vpc_cidr" {
  type = string
  description = "VPC의 CIDR 값"
}

variable "azs_count" {
  type = number
  description = "Availability Zones의 갯수"
  default = 3
}

variable "enable_nat_gateway" {
  type = bool
  description = "Nat Gateway 생성 여부"
  default = true
}

variable "single_nat_gateway" {
  type = bool
  description = "VPC에 단 하나의 NAT Gateway를 둘 것인지의 여부. (False시 서브넷별로 NAT Gateway 생성)"
  default = true
}

variable "enable_dns_hostnames" {
  type = bool
  description = "VPC의 DNS hostname을 생성할 것인지의 여부"
  default = true
}
