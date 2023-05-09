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

/**
 *  Amazon Kinesis > Delivery streams > Create delivery stream
 */
resource "aws_kinesis_firehose_delivery_stream" "this" {

  ## Choose source and destination
  # Source: Direct PUT

  # Destination: Amazon S3
  destination = "extended_s3"

  ## Delivery stream name
  # Delivery stream name: 
  name = local.name

  extended_s3_configuration {

    ## Transform and convert records
    # Data transformation: Disabled
    # Convert record format: Disabled

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

    # S3 bucket: s3://bucketname
    bucket_arn = data.aws_s3_bucket.this.arn

    # Dynamic partitioning: Disabled

    # S3 bucket prefix
    prefix = var.s3_prefix

    # S3 bucket error output prefix
    error_output_prefix = var.s3_error_prefix

    ## S3 buffer hints
    # Buffer size: 5 MiB
    buffer_size = var.buffer_size

    # Buffer interval: 300 s
    buffer_interval = var.buffer_interval

    ## S3 compression and encryption
    # Compression for data records: GZIP
    compression_format = "GZIP"

    # Encryption for data records: Disabled

    ## Backup settings
    # Source record backup in Amazon S3: Disabled

    ## Advanced settings

    # Enable server-side encryption for source records in delivery stream: No

    # Amazon CloudWatch error logging: Enabled
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${local.name}"
      log_stream_name = "S3Delivery"
    }

    # Permissions: Choose existing IAM role
    role_arn = aws_iam_role.this.arn

  }

  # Tags
  tags = var.env.tags
}
