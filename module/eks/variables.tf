variable "region" {
  type = string
  description = "EKS가 배포될 AWS 리전"
  default = "ap-northeast-2"
}

variable "eks_env" {
  type = string
  description = "배포된 EKS의 환경 (ex. dev, qa, prod)"
  default = "dev"
}

variable "eks_version" {
  type = string
  description = "배포할 EKS의 Kubernetes 버전 (ex. 1.29)"
  default = "1.29"
}

variable "vpc_id" {
  type = string
  description = "EKS가 배포될 VPC의 고유 ID"
}

variable "subnet_ids" {
  type = list(string)
  description = "EKS가 사용할 Subnet의 고유 ID 리스트"
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

variable "eks_managed_node_groups" {
  type = map(object({
    name                       = string
    instance_types             = list(string)
    min_size                   = number
    max_size                   = number
    desired_size               = number
    cluster_primary_security_group_id = string
    vpc_security_group_ids            = list(string)
  }))
  description = "EKS의 Node Group에 대한 스펙을 명시합니다. locals.tf에서 관리합니다."
}

variable "node_group_instance_types" {
  type = list(string)
  description = "EKS Cluster의 Node가 사용할 EC2 인스턴스 스펙 리스트"
  default = ["t3.large"]
}

variable "node_group_min_size" {
  type = number
  description = "Scaling 과정에서 EKS가 가용할 Node Group의 최소 갯수"
  default = 1
}
  
variable "node_group_max_size" {
  type = number
  description = "Scaling 과정에서 EKS가 가용할 Node Group의 최대 갯수"
  default = 3
}
  
variable "node_group_desired_size" {
  type = number
  description = "일반적인 상황에서 EKS가 가용할 Node Group의 갯수"
  default = 1
}

variable "node_group_ami_type" {
  type = string
  description = "EKS 노드 그룹의 ami type"
  default = "AL2_x86_64"
  
}
