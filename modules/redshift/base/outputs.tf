output "ssm_parameter" {
  value = {
    for k, v in aws_ssm_parameter.this :
    k => v.value
  }
}

output "subnet_groups" {
  value = {
    front = aws_redshift_subnet_group.this.id
  }
}
