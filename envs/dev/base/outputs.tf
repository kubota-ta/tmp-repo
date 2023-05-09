output "security_group" {
  description = "Security groups"
  value = {
    for k, v in module.sg-self:
      k => v.security_group_id
  }
}
