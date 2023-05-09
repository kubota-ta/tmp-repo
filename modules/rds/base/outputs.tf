output "ssm_parameter" {
  value = module.db_user.ssm_parameter
}

output "subnet_groups" {
  value = {
    private = aws_db_subnet_group.this.id
  }
}
