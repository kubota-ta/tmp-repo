output "ssm_parameter" {
  value = {
    for k, v in aws_ssm_parameter.this :
    k => v.value
  }
}
