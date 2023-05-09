output "security_group" {
  description = "Security groups"
  value = merge({
    for k, v in module.sg-trust : k => v.security_group_id
    }, {
    public-http = module.sg-public-http.security_group_id
    public-web  = module.sg-public-web.security_group_id
  })
}

output "waf" {
  description = "WAF"
  value = {
    for k, v in module.waf-trust : k => v.acl.arn
  }
}

output "iam_policy" {
  description = "IAM policy ARNs"
  value       = module.iam-role-policies.policy_arns
}