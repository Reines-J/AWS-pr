
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version = "18.4.1"
  cluster_name = "${var.resource_tag}"
  cluster_version = "1.21"
  vpc_id = aws_vpc.vpc.id
  subnet_ids = data.aws_subnet_ids.all.ids
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  create_iam_role = false
  iam_role_arn = aws_iam_role.eks-cluster.arn
  enable_irsa = true
  cluster_addons = {
    coredns = {
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {}
    vpc-cni = {
      resolve_conflicts = "OVERWRITE"
    }
  }
  eks_managed_node_groups = {
    test = {
      desired_size = 2
      max_size     = 5
      min_size     = 2
      create_launch_template = true
      public_ip = true
      key_name = aws_key_pair.terra-key.key_name
      instance_types    = ["t3.small"]
      create_iam_role = false
      iam_role_arn = aws_iam_role.eks-node.arn
      vpc_security_group_ids = [aws_security_group.eks-sg.id]
    }
  }
}
