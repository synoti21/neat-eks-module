variable "requester_name" {
  type = string
  description = "vpc peering 요청을 request 하는 vpc의 name"
}

variable "requester_vpc_id" {
  type = string
  description = "vpc peering 요청을 request 하는 vpc의 ID"
}

variable "region" {
  type = string
  description = "EKS가 배포될 AWS 리전"
  default = "ap-northeast-2"
}

