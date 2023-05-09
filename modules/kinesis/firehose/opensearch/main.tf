locals {
  name      = "${var.env.prefix}-${var.name}"
  role_name = "${var.env.prefix}-firehose-${var.name}"
}

data "aws_s3_bucket" "this" {
  bucket = var.s3_bucket
}

/**
 * IAM
 */
data "aws_caller_identity" "current" {}
data "template_file" "this" {
  for_each = toset([
    "KinesisFirehoseServiceRole",
  ])
  template = file("${path.module}/files/${each.key}.yml")
  vars = {
    aws_id         = "${data.aws_caller_identity.current.account_id}",
    stream_name    = "${local.name}",
    s3_bucket_name = data.aws_s3_bucket.this.id,
    es_arn         = var.es_arn,
    es_index       = var.es_index,
    lambda_function = (
      var.lambda_function == null ?
      "arn:aws:lambda:ap-northeast-1:${data.aws_caller_identity.current.account_id}:function:%FIREHOSE_POLICY_TEMPLATE_PLACEHOLDER%"
      : var.lambda_function
    )
  }
}

resource "aws_iam_policy" "this" {
  for_each = data.template_file.this
  name     = "${local.role_name}-${each.key}"
  policy   = jsonencode(yamldecode(each.value.rendered)["Policy"])
}

/**
 * IAM > Roles
 */
resource "aws_iam_role" "this" {

  # Select type of trusted entity: AWS service
  # Choose a use case: Kinesis Firehose
  assume_role_policy = jsonencode(
    yamldecode(values(data.template_file.this)[0].rendered)["AssumeRole"]
  )

  # Attach permissions policies
  managed_policy_arns = values(aws_iam_policy.this)[*].arn

  # Add tags
  tags = var.env.tags

  # Role name
  name = local.role_name

  # Role description
  # skip

  path = "/service-role/"
}

/**
 * CloudWatch > Log groups
 */
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/kinesisfirehose/${local.name}"
  retention_in_days = var.cloudwatch_logs_retention
  tags              = var.env.tags
}

resource "aws_cloudwatch_log_stream" "this" {
  for_each       = toset(["DestinationDelivery", "BackupDelivery"])
  name           = each.key
  log_group_name = aws_cloudwatch_log_group.this.name
}

/**
 *  Amazon Kinesis > Delivery streams > Create delivery stream
 */
resource "aws_kinesis_firehose_delivery_stream" "this" {

  ## Choose source and destination
  # Source: Direct PUT

  # Destination: Amazon OpenSearch Service
  destination = "elasticsearch"

  ## Delivery stream name
  # Delivery stream name: 
  name = local.name

  elasticsearch_configuration {

    ## Transform and convert records
    processing_configuration {
      # Data transformation: Enabled
      enabled = var.lambda_function == null ? "false" : "true"

      # AWS Lambda function
      dynamic "processors" {
        for_each = var.lambda_function == null ? [] : [1]
        content {
          type = "Lambda"

          parameters {
            parameter_name  = "LambdaArn"
            parameter_value = var.lambda_function
          }
        }
      }

      # Buffer size: 3 MB
      # Buffer interval: 60 s
    }

    # Convert record format: Disabled

    ## Destination settings

    # OpenSearch Service domain
    domain_arn = var.es_arn

    # Index
    index_name = var.es_index

    # Index rotation
    index_rotation_period = "OneDay"

    # Retry duration
    retry_duration = 300

    ## Buffer hints
    # Buffer size
    buffering_size = 5
    # Buffer interval
    buffering_interval = 60

    ## Backup settings

    # Source record backup in Amazon S3
    s3_backup_mode = "FailedDocumentsOnly"

    ##-- ここから
    ## マネジメントコンソール上では"Advanced settings"の項で設定します
    # Amazon CloudWatch error logging: Enabled
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${local.name}"
      log_stream_name = "DestinationDelivery"
    }

    # Permissions: Choose existing IAM role
    role_arn = aws_iam_role.this.arn
    ##-- ここまで
  }

  s3_configuration {

    # S3 backup bucket
    bucket_arn = data.aws_s3_bucket.this.arn

    # S3 backup bucket prefix
    prefix = var.s3_prefix

    # S3 backup bucket error output prefix

    ## Buffer hints
    # Buffer size
    buffer_size = 5

    # Buffer interval
    buffer_interval = 60

    # Compression for data records: GZIP
    compression_format = "GZIP"

    # Encryption for data records: Disabled

    ##-- ここから
    ## マネジメントコンソール上では"Advanced settings"の項で設定します
    # Amazon CloudWatch error logging: Enabled
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${local.name}"
      log_stream_name = "BackupDelivery"
    }

    # Permissions: Choose existing IAM role
    role_arn = aws_iam_role.this.arn
    ##-- ここまで
  }

  ## Advanced settings

  # Enable server-side encryption for source records in delivery stream
  server_side_encryption {
    enabled  = true
    key_type = "AWS_OWNED_CMK"
  }

  #(前項で設定済み)
  # Amazon CloudWatch error logging
  # Permissions

  # Tags
  tags = var.env.tags
}
