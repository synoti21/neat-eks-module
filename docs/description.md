## Terraform 모듈화 설계
- EKS 모듈화 단위를 어떻게 할 것인지? (리소스별 분리? or 하나로 묶어서 분리?)
- 하드코딩된 일부 필드 (ex. CIDR 대역 등)의 입력값을 어떻게 받을 것인지? (그대로 문자열로? 함수를 이용해서?)
- EKS 리소스 자체 외의 부가적인 리소스 (ex. ebs-csi-driver, karpenter 등)을 어느 범위까지 terraform에 포함?

## Intention
체계적인 Terraform 모듈화를 통해 다음과 같은 장점을 가져오려 한다.
- AWS가 제공하는 EKS 모듈을 가져오되, 고정되지 않은 Customizable field는 변수로 대체
- CIDR 분할 범위를 `cidrsubnets` 함수를 통해 일정하게 분할.
- 대다수의 addon을 Terraform을 통해 관리함으로써 manual한 영역 최소화


## 모듈화 과정
### 1. EKS를 이루고 있는 리소스를 다음과 같이 vpc, eks, vpc-peering으로 분리한다.

**As-Is**
```
eks
└──root
    ├── aws-ebs-csi-driver-trust-policy.json
    ├── main.tf
    ├── outputs.tf
    ├── terraform.tf
    └── variables.tf
    
```
**To-Be**
```
eks
├── module
│   ├── eks
│   │   ├── ebs-csi.tf
│   │   ├── locals.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── vpc
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── vpc-peering
│   │   ├── main.tf
│   │   └── variables.tf
│   ├── s3_gateway
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── dynamoDB_gateway
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
└── root
    ├── locals.tf
    ├── main.tf
    ├── outputs.tf
    ├── terraform.tf
    └── variable.tf
```
더 복잡해진것 아닌가? 싶지만 실제로는 module 하위 파일은 신경쓰지 않아도 되며, root폴더 내 변수 저장용 variable.tf만 변경하면 된다.
그 전에는 main.tf에서 모든 resource를 하드코딩 했어야 했다.

모듈화는 기본적으로 **"Root Module이 핵심 리소스를 모듈화한 Child Module를 Import"** 하는 방식으로 진행한다.
- Child Module 은 핵심 리소스를 포함하는 모듈이며, 세부 사항들이 동적인 값들로 이루어져 있다.
```
module "eks" {
...
  vpc_id                         = var.vpc_id
  subnet_ids                     = var.subnet_ids
...
}
```
- Root Module 은 환경에 맞게 Child Module을 Customize 한 상태로 Import를 하는 Module이다.
```
module "eks_test_tf" {
  source = "../module/eks"
  vpc_id = module.vpc_test_tf.vpc_id
  subnet_ids = module.vpc_test_tf.private_subnets
  ...
}
```
위 원칙에 의거, 리소스를 VPC, EKS, VPC-Peering으로 분리한 후, 각각 Child Module로 통합하여 관리가 용이하도록 한다.

### 2. Local 환경변수 및 Locals.tf 관리
파일을 보면 `locals.tf`라는 새로운 파일이 보일 것이다. 이는 `Local`환경변수를 관리하기 위함인데, `Local` 환경변수를 사용하는 목적은 다음과 같다.
- 중복된 코드 최소화 (Don't Repeat Yourself)
- 가독성 향상

`Varaible`과 `Local`의 차이점은 다음과 같다.
- variable: 단일 필드의 매개변수
- locals: 중복된 값이나 복잡한 표현식을 임시로 변수에 저장 (매개변수가 아님!!)


위 EKS 모듈에서 locals를 사용한 필드는 다음 두 필드다.
- Child Module: `cluster_addons`
- Root Module: `eks_managed_node_groups`

Child Module의 `cluster_addons`는 다음과 같은 필드를 지니고 있다.
```
locals {
  cluster_addons = {
    aws-ebs-csi-driver = {
        addon_version = var.eks_addon_version.aws_ebs_csi_driver
        service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }
}
```
지금은 하나의 addon만 있어 비교적 필드가 간결하지만, 만일 여러개의 addon을 추가한다면 Main.tf의 가독성이 현저히 떨어질 것이다.

따라서, Locals 환경변수를 통해 다음과 같이 축약한다.
```
  cluster_addons = local.cluster_addons
```

다음으로 사용한 Root Module의 `eks_managed_node_groups`는 다음과 같은 필드를 지니고 있다. 
```
locals {
    eks_managed_node_groups = {
        one = {
            name = "${var.eks_env}-node-group-1"
            instance_types = ["t3.large"]

            min_size     = 1
            max_size     = 3
            desired_size = 1

            cluster_primary_security_group_id = module.eks.cluster_primary_security_group_id
            vpc_security_group_ids            = [module.eks.node_security_group_id]
        }
    }
}
```
이 역시 매우 복잡한 표현식을 지니고 있으므로, 간결하게 표현 및 관리의 용이를 위해 Locals 함수로 축약한다.
```
eks_managed_node_groups = local.eks_managed_node_groups
```
위의 경우는 특이하게 필드가 하드코딩 되어있는 것을 볼 수 있는데, `locals` 역시 환경변수를 저장하기 위해 사용되므로, node groups를 별도로 추가할 때 더욱 편리하게 추가 및 가독성 향상을 위해 실제 값으로 대체했다.

### 3. 각종 addon들 Terraform 코드로 대체
우선 ebs-csi-driver를 웹 콘솔이 아닌 Terraform으로 설치가 가능하도록 구성한다.

**As-Is**
- 웹 콘솔을 통해 Manual하게 ebs-csi-driver를 설치한다.
- 수동으로 IAM Policy를 만든 후, attach 해야 한다.
- OIDC Provider의 unique 값을 알아야 하는 등, 과정이 복잡하다.

**To-Be**
- ebs-csi-driver에 필요한 IAM policy를 생성하기 위해 AWS에서 제공하는 IAM Terraform 모듈을 사용한다.
- 자동으로 알맞은 IAM Policy를 제공해주므로, 신경쓰지 않아도 된다.
- EKS 생성 시, 자동으로 Deployment 및 IRSA를 주입한다.

ebs-csi-driver에 필요한 IAM Policy 생성 Terraform 모듈은 다음과 같다.
```
module "ebs_csi_irsa_role" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name             = "${var.eks_env}-ebs-csi-role"
  attach_ebs_csi_policy = true

  oidc_providers = {
    ex = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }
}
```
- 자동으로 ebs-csi-driver에 필요한 Role을 생성한다.
- EKS 모듈의 OIDC Provider를 자동으로 import한다.
- 대상 Service Account를 위의 코드에서 지정한다.
위에서 생성한 IAM Role은 ebs-csi-driver에서 다음의 코드를 통해 사용한다.
```
locals {
  cluster_addons = {
    aws-ebs-csi-driver = {
        addon_version = var.eks_addon_version.aws_ebs_csi_driver
        service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn # IAM Role 사용
    }
  }
}
```

## TO-DO
- Kubernetes Provider를 통해 모든 Kubernetes의 부가 서비스를 Terraform으로 관리한다.
    - gp3 StorageClass
    - Karpenter
    - Exteral DNS

Kubernetes, Helm Provider를 통해 이를 실현할 수 있다.