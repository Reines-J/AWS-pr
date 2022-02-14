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

resource "aws_iam_role" "eks-node" {
  name = "terra-eks-node"
  assume_role_policy = data.aws_iam_policy_document.node-assume.json
}

resource "aws_iam_role_policy" "node-autoscaling" {
  name = "node-autoscaling"
  role = aws_iam_role.eks-node.id
  policy = data.aws_iam_policy_document.node-autoscaling.json
}

resource "aws_iam_role_policy" "node-efscsi" {
  name = "node-efscsi"
  role = aws_iam_role.eks-node.id
  policy = data.aws_iam_policy_document.node-efscsi.json
}

resource "aws_iam_role_policy" "node-albcontroller" {
  name = "node-albcontroller"
  role = aws_iam_role.eks-node.id
  policy = data.aws_iam_policy_document.node-albcontroller.json
}

resource "aws_iam_role_policy" "node-certmanager"{
  name = "node-certmanater"
  role = aws_iam_role.eks-node.id
  policy = data.aws_iam_policy_document.cert-manager.json
}

resource "aws_iam_role_policy" "node-externaldns" {
  name = "node-externaldns"
  role = aws_iam_role.eks-node.id
  policy = data.aws_iam_policy_document.node-externaldns.json
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKSWorkerNodePolicy"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEC2ContainerRegistryReadOnly"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonRoute53FullAccess"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonRoute53FullAccess"
  role = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "CloudWatchAgentServerPolicy"{
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role = aws_iam_role.eks-node.name
}

resource "aws_iam_role_policy_attachment" "node-AmazonEKS_CNI_Policy"{
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role = aws_iam_role.eks-node.name
}
