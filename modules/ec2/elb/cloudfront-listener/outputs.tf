output "target_groups" {
  value = {
    for k, v in aws_lb_target_group.this : k => v.arn
  }
}
