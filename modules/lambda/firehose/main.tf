locals {
  func_name = "${var.env.prefix}-${var.name}"
  role_name = "${var.env.prefix}-lambda-${var.name}"
}

/**
 * IAM
 */
data "aws_caller_identity" "current" {}
data "template_file" "this" {
  for_each = toset([
    "AWSLambdaBasicExecutionRole",
  ])
  template = file("${path.module}/files/${each.key}.yml")
  vars = {
    aws_id        = "${data.aws_caller_identity.current.account_id}",
    function_name = "${local.func_name}",
  }
}

resource "aws_iam_policy" "this" {
  for_each = data.template_file.this
  name     = "${local.role_name}-${each.key}"
  policy   = jsonencode(yamldecode(each.value.rendered)["Policy"])
}

/**
 * IAM > Roles
 * インスタンスプロファイル用のIAMロールを作成
 */
resource "aws_iam_role" "this" {

  # Select type of trusted entity: AWS service
  # Choose a use case: EC2
  assume_role_policy = jsonencode(
    yamldecode(data.template_file.this["AWSLambdaBasicExecutionRole"].rendered)["AssumeRole"]
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
  name              = "/aws/lambda/${local.func_name}"
  retention_in_days = var.cloudwatch_logs_retention
  tags              = var.env.tags
}


/**
 * Lambda > Functions > Create function
 */
resource "aws_lambda_function" "this" {
  ## Author from scratch

  ## Basic information

  # Function name
  function_name = local.func_name

  # Runtime
  runtime = var.runtime

  # Architecture
  architectures = [var.architecture]

  ## Permissions

  # Execution role
  role = aws_iam_role.this.arn

  ## Advanced settings
  ## Code signing: na
  ## Network: na

  /**
   * [Created function] > Code > [Upload from] > .zip file
   */
  filename = var.filename
  handler  = var.handler

  /**
   * [Created function] > Configuration
   */
  ## General configuration
  timeout = var.timeout

  ## Tags
  tags = var.env.tags
}
