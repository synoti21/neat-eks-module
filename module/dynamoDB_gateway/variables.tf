variable "vpc_name" {
  type = string
  description = "vpc 이름을 입력해주세요"
  default = "dev"
}

variable "availability_zones" {
  type = list(string)
  description = "현재 사용중인 vpc 가용영역들을 모두 입력해주세요"
  default = ["ap-northeast-2a","ap-northeast-2b","ap-northeast-2c"]
}