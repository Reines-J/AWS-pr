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

data "aws_iam_policy_document" "node-assume" {
  statement {
    sid = ""
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
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
        "system:serviceaccount:eks:aws-node",
        "system:serviceaccount:eks:alb-controller",
        "system:serviceaccount:eks:cluster-autoscaler",
        "system:serviceaccount:eks:efs-csi-controller-sa",
        "system:serviceaccount:eks:cert-manager",
        "system:serviceaccount:eks:external-dns"
      ]
    }
  }

}

data "aws_iam_policy_document" "node-autoscaling" {
  source_json = "${file("iam_policy/autoscaler.json")}"
}

data "aws_iam_policy_document" "node-efscsi" {
  source_json = "${file("iam_policy/efscsidriver.json")}"
}

data "aws_iam_policy_document" "cert-manager" {
  source_json = "${file("iam_policy/certmanager.json")}"
}

data "aws_iam_policy_document" "node-albcontroller"{
  source_json = "${file("iam_policy/albingress.json")}"
}

data "aws_iam_policy_document" "node-externaldns"{
  source_json = "${file("iam_policy/externaldns.json")}"
}
