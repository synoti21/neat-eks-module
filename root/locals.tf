locals {
    eks_managed_node_groups = {
        first = {
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