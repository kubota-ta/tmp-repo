data "aws_caller_identity" "current" {}

/**
 * ElastiCache > Subnet groups > [Create Subnet Group]
 */
resource "aws_elasticache_subnet_group" "this" {

  # Name
  name = "${var.env.prefix}-private"

  # Description
  description = "private"

  # VPC
  ## Add subnets
  # Availability Zones
  # Subnet ID
  subnet_ids = var.subnet_ids

}

/**
 * Amazon SNS > Topics > [Create topic]
 */
resource "aws_sns_topic" "this" {

  ## Details

  # Type: Standard

  # Name
  name = "${var.env.prefix}-elasticache-notification"

  # Display name
  display_name = "${var.env.project.name}-sns"

  # Content-based message deduplication: No

  ## Encryption: na
  ## Access policy: na
  ## Delivery status logging: na

  ## Tags
  tags = var.env.tags

}

/**
 * Amazon SNS > Subscriptions > [Create subscription]
 */
resource "aws_sns_topic_subscription" "this" {
  for_each = var.subscription

  ## Details

  # Topic ARN
  topic_arn = aws_sns_topic.this.arn

  # Protocol
  protocol = each.value

  # Endpoint
  endpoint = each.key

  ## Subscription filter policy: na
  ## Redrive policy (dead-letter queue): na

}

/**
 * Lambda (filter notice to sns from redis)
 */
module "lambda" {
  source    = "../../lambda/elasticache"
  env       = var.env
  prefix    = var.lambda_prefix
  sns_topic = aws_sns_topic.this.arn
}

resource "aws_sns_topic" "lambda" {
  name = "${var.lambda_prefix}redis-to-lambda"
  tags = var.env.tags
}

resource "aws_sns_topic_subscription" "lambda" {
  topic_arn = aws_sns_topic.lambda.arn
  protocol  = "lambda"
  endpoint  = module.lambda.arn
}

resource "aws_lambda_permission" "this" {
  statement_id  = "sns-ap-northeast-1-${data.aws_caller_identity.current.account_id}-${var.lambda_prefix}redis-to-lambda"
  action        = "lambda:InvokeFunction"
  function_name = module.lambda.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.lambda.arn
}
