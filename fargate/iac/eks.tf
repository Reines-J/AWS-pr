
module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version = "17.22.0"
  cluster_name = "${var.resource_tag}"
  cluster_version = "1.21"
  vpc_id = aws_vpc.vpc.id
  subnets = data.aws_subnet_ids.all.ids
  fargate_subnets = data.aws_subnet_ids.pri.ids
  cluster_endpoint_private_access = true
  cluster_endpoint_public_access = true
  manage_cluster_iam_resources = false
  manage_worker_iam_resources = false
  cluster_iam_role_name = aws_iam_role.eks-cluster.name
  enable_irsa = true
  manage_aws_auth = false
  create_fargate_pod_execution_role = false
  fargate_pod_execution_role_name = aws_iam_role.eks-fargate.name
  node_groups = {
    eks_nodes = {
      desired_capacity = 2
      max_capacity     = 5
      min_capacity     = 2
      instance_types    = ["t3.small"]
      iam_role_arn = "arn:aws:iam::<>"
    }
  }
  fargate_profiles = {
    kube-dns = {
      name = "kube-dns"
      selectors = [
        {
          namespace = "kube-system"
          labels = {
            k8s-app = "kube-dns"
          }
        }
      ]
      tags = {
        Owner = "kube-dns"
      }
    }

    agent = {
      name = "agent"
      selectors = [
        {
          namespace = "cw"
        }
      ]
      subntes = []
      timeouts = {
        delete = "20m"
      }
      tags = {
        Owner = "agent"
      }
    }
  }
}
