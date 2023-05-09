output "subnet_groups" {
  value = {
    private = aws_elasticache_subnet_group.this.id
  }
}

output "sns_topic" {
  value = {
    notification = aws_sns_topic.lambda.arn
  }
}
