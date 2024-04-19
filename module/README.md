# VPC Endpoint Terrafrom 모듈화
위 Repository는 Child Modules를 담은 Repository다. 높은 재사용성을 위해 다음과 같이 모듈화를 한다.
```bash
modules
├── dynamoDB_gateway
│   ├── main.tf
│   ├── outputs.tf
│   └── variables.tf
└── s3_gateway
    ├── main.tf
    ├── outputs.tf
    └── variables.tf

```
각 Child 모듈은 `main.tf`, `outputs.tf`, `variables.tf`로 이루어져 있다.
- `main.tf`: 인프라 리소스가 선언되어 있는 코드. 주요 필드가 모두 변수로 선언되어 있다.
- `outputs.tf`: `terraform apply` 이후, 출력값을 설정하는 코드.
- `variables.tf`: 다른 모듈로부터 입력받을 입력 값들을 관리하는 코드. `main.tf`에서 사용하는 변수들이 이곳에 선언되어 있다.

이 Child 모듈은 다른 Root 모듈로부터 사용된다. Root 모듈은 terraform 명령어를 실행하는 모듈이며, 여기서는 각종 환경들이 등이 속한다.

Child 모듈을 사용하기 위해서는 Root 모듈의 `main.tf`에서 위 모듈을 import 한다.
- Root 모듈 (ex. dev)의 `main.tf`에서 Import
```
module "s3_gateway_endpoint" {
    source = "../module/s3_gateway"
    vpc_name = var.vpc_name
}

module "dynamoDB_gateway_endpoint" {
    source = "../module/dynamoDB_gateway"
    vpc_name = var.vpc_name
}
```
변수는 Root 모듈의 `variable.tf`에서 관리된다.
```
variable "vpc_name" {
    type = string
    description = "vpc name"
    default = "dev"
}

variable "availability_zones" {
    type = list(string)
    description = "number of availability zones"
    default = ["ap-northeast-2a","ap-northeast-2b","ap-northeast-2c"]
}
```