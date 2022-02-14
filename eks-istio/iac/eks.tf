

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name = "${var.resource_tag}"
  cluster_version = "1.21"
  vpc_id = aws_vpc.vpc.id
  subnets = data.aws_subnet_ids.all.ids
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  manage_cluster_iam_resources = false
  manage_worker_iam_resources = false
  cluster_iam_role_name = aws_iam_role.eks-cluster.name
  enable_irsa = true
  manage_aws_auth = false
  node_groups = {
    eks_nodes = {
      additional_tags = merge(var.eks_tag,{
        "k8s.io/cluster-autoscaler/enabled" =	"true"
        "k8s.io/cluster-autoscaler/${var.resource_tag}" =	"owned"
      })
      public_ip = true
      desired_capacity = 2
      max_capacity     = 5
      min_capacity     = 2
      iam_role_arn = aws_iam_role.eks-node.arn
      public_ip = true
      key_name         = aws_key_pair.terra-key.key_name
      instance_types    = ["t3.small"]
      source_security_group_ids = [
        aws_security_group.eks-sg.id
      ]
    }
  }
}
