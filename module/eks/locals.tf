locals {
  cluster_addons = {
    aws-ebs-csi-driver = {
        addon_version = var.eks_addon_version.aws_ebs_csi_driver
        service_account_role_arn = module.ebs_csi_irsa_role.iam_role_arn
    }
  }
}