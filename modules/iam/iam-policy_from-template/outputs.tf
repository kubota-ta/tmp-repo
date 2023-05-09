output "policy_arns" {
  value = {
    for k, v in var.template :
    k => concat(
      v.aws_managed_policies,
      [for i in v.available_customer_managed_policies :
      local.available_customer_managed_policies[i]],
      [for i, j in v.customer_managed_policies :
      aws_iam_policy.this[i].arn],
    )
  }
}
