output "ip_set" {
  value = aws_wafv2_ip_set.this
}

output "acl" {
  value = module.acl.acl
}
