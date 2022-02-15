resource "aws_iam_role" "eks-cluster" {
  name = "terra-eks-cluster"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.cluster-assume.json
}

resource "aws_iam_role_policy" "cluster-metric" {
  name = "cluster-metric"
  role = aws_iam_role.eks-cluster.id
  policy = data.aws_iam_policy_document.cluster-metric.json
}

resource "aws_iam_role_policy" "cluster-elbpermission" {
  name = "cluster-elbpermission"
  role = aws_iam_role.eks-cluster.id
  policy = data.aws_iam_policy_document.cluster-elbpermission.json
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster-AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role = aws_iam_role.eks-cluster.name
}

resource "aws_iam_role" "eks-fargate" {
  name = "eks-fargate"
  assume_role_policy = data.aws_iam_policy_document.fargate-assume.json
}

resource "aws_iam_role_policy_attachment" "eks-fargate"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role = aws_iam_role.eks-fargate.name
}

resource "aws_iam_role_policy_attachment" "eks-fargate-attach"{
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role = aws_iam_role.eks-fargate.name
}