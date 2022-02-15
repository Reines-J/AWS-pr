data "aws_iam_policy_document" "cluster-assume" {
  statement {
    sid = ""
    principals {
      type = "Service"
      identifiers = [ "eks.amazonaws.com" ]
    }
    actions = ["sts:AssumeRole"]
  }
}

data "aws_iam_policy_document" "cluster-metric" {
  statement {
    actions =[
        "cloudwatch:PutMetricData"
    ]
    resources = [ "*" ]
  }
}

data "aws_iam_policy_document" "cluster-elbpermission" {
  statement {
    actions = [
        "ec2:DescribeAccountAttributes",
        "ec2:DescribeAddresses",
        "ec2:DescribeInternetGateways"
    ]
    resources = [ "*" ]
  }
}

data "aws_iam_policy_document" "fargate-assume" {
  statement {
    sid = ""
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [ "eks-fargate-pods.amazonaws.com" ]
    }
  }
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect = "Allow"
    principals {
      type = "Federated"
      identifiers = [ module.eks.oidc_provider_arn ]
    }
    condition {
      test = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:aud"
      values = [
        "sts.amazonaws.com"
      ]
    }
    condition {
      test = "StringEquals"
      variable = "${replace(module.eks.cluster_oidc_issuer_url, "https://", "")}:sub"
      values = [
        "system:serviceaccount:cw:aws-cloudwatch-metrics",
        "system:serviceaccount:cw:aws-for-fluent-bit"
      ]
    }
  }
}
