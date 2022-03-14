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

data "aws_iam_policy_document" "firehose-assume" {
  statement {
    sid = ""
    principals {
      type = "Service"
      identifiers = [ "firehose.amazonaws.com" ]
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

resource "aws_cloudwatch_log_resource_policy" "elastic-log" {
  policy_name = "/aws/opensearch/elastic-log"

  policy_document = <<CONFIG
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "es.amazonaws.com"
      },
      "Action": [
        "logs:PutLogEvents",
        "logs:PutLogEventsBatch",
        "logs:CreateLogStream"
      ],
      "Resource": "arn:aws:logs:*"
    }
  ]
}
CONFIG
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
        "system:serviceaccount:metric:aws-cloudwatch-metrics",
        "system:serviceaccount:logging:aws-for-fluent-bit"
      ]
    }
  }
}