resource "aws_iam_role" "eks-cluster" {
  name = "terra-eks-cluster"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.cluster-assume.json
}

resource "aws_iam_role" "eks-node" {
  name = "eks-node"
  assume_role_policy = data.aws_iam_policy_document.node-assume.json
}

resource "aws_iam_role" "firehose" {
  name = "terra-firehose"
  path = "/"
  assume_role_policy = data.aws_iam_policy_document.firehose-assume.json
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

resource "aws_iam_role_policy" "fluentbit" {
  name = "fluentbit"
  role = aws_iam_role.eks-node.id
  policy = data.aws_iam_policy_document.fluent-kinesis.json
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy"{
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "node-cni"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy" "firehose" {
  name = "firehose"
  role = aws_iam_role.firehose.id
  policy = data.aws_iam_policy_document.firehose-opensearch.json
}
