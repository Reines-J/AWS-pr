resource "aws_kinesis_firehose_delivery_stream" "firehose-elastic" {
  name        = "${var.resource_tag}"
  destination = "elasticsearch"

  elasticsearch_configuration {
    domain_arn = aws_elasticsearch_domain.elastic-log.arn
    role_arn   = aws_iam_role.firehose.arn
    index_name = "fluent"
    index_rotation_period = "OneMonth"
    type_name  = ""
    s3_backup_mode     = "FailedDocumentsOnly"
  }

  s3_configuration {
    role_arn           = aws_iam_role.firehose.arn
    bucket_arn         = aws_s3_bucket.firehose.arn
    buffer_size        = 30
    buffer_interval    = 300
    compression_format = "GZIP"
  }
}

resource "aws_s3_bucket" "firehose" {
  bucket = "${var.resource_tag}"
}

resource "aws_elasticsearch_domain" "elastic-log" {
  domain_name           = "${var.resource_tag}"
  elasticsearch_version = "7.10"

  cluster_config {
    dedicated_master_enabled = false
    # dedicated_master_count = 3 or 5
    # dedicated_master_type = 
    instance_type = "t3.small.elasticsearch"
    instance_count = 1
    zone_awareness_config {
      availability_zone_count = 2
    }
  }

  tags = {
    Domain = "Reines"
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  domain_endpoint_options{
    enforce_https = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  encrypt_at_rest{
    enabled = true
  }

  node_to_node_encryption{
    enabled = true
  }

  advanced_security_options {
    enabled = true
    internal_user_database_enabled = true
    master_user_options{
      master_user_name = "adminadmin"
      master_user_password = "1Q2w3e4r!"
    }
  }

  log_publishing_options {
    cloudwatch_log_group_arn = data.aws_cloudwatch_log_group.opensearch.arn
    log_type                 = "INDEX_SLOW_LOGS"
  }
}

resource "aws_elasticsearch_domain_policy" "elastic-log" {
  domain_name = aws_elasticsearch_domain.elastic-log.domain_name

  access_policies = <<POLICIES
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": "es:*",
      "Resource": "arn:aws:es:ap-northeast-2:<id>:domain/elastic-log/*"
    }
  ]
}
POLICIES
}