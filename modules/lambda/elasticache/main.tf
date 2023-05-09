/**
 * こちらの手順で作成されるものです
 * https://confl.arms.dmm.com/pages/viewpage.action?pageId=877823816
 */
locals {
  name = "${var.env.project.name}-lambda-redis-event-filter-role"
}

## IAMポリシー作成
data "aws_caller_identity" "current" {}
data "template_file" "this" {
  for_each = toset([
    "AWSLambdaBasicExecutionRole",
    "AWSLambdaSNSPublishPolicyExecutionRole",
  ])
  template = file("${path.module}/files/${each.key}.yml")
  vars = {
    aws_id        = "${data.aws_caller_identity.current.account_id}",
    function_name = "RedisEventFilter",
  }
}
resource "aws_iam_policy" "this" {
  for_each = data.template_file.this
  name     = "${each.key}-${local.name}"
  policy   = jsonencode(yamldecode(each.value.rendered)["Policy"])
}

## IAMロール作成
resource "aws_iam_role" "this" {
  assume_role_policy = jsonencode(
    yamldecode(data.template_file.this["AWSLambdaBasicExecutionRole"].rendered)["AssumeRole"]
  )
  managed_policy_arns = values(aws_iam_policy.this)[*].arn
  tags                = var.env.tags
  name                = local.name
  path                = "/service-role/"
}

## CloudWatch > Log groups 作成
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.prefix}RedisEventFilter"
  retention_in_days = 7
  tags              = var.env.tags
}

## lambda function 作成
resource "aws_lambda_function" "this" {
  function_name = "${var.prefix}RedisEventFilter"
  runtime       = "python3.9"
  role          = aws_iam_role.this.arn
  #filename =
  s3_bucket = "ginfra-stub-work"
  s3_key    = "lambda/RedisEventFilter.zip"
  handler   = "lambda_function.lambda_handler"
  environment {
    variables = {
      sns_topic = var.sns_topic
      subject   = "AWS Notification Message"
    }
  }
  tags = var.env.tags
}
