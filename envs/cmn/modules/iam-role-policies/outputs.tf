locals {
  policies = yamldecode(file("${path.module}/files/policies.yml"))
  roles    = yamldecode(file("${path.module}/files/roles.yml"))
  features = local.roles[var.use_case]
}

output "aws_managed_policies" {
  description = "AWS managed policies"
  value = local.features == [] ? [] : distinct(concat([
    for f in local.features : [
      for p in lookup(local.policies[f], "aws_managed", []) : p
    ]
  ]...))
}

output "customer_managed_policies" {
  description = "Customer managed policy templates"
  value = merge([
    for f in local.features : {
      for p in lookup(local.policies[f], "customer_managed", []) :
      #"${p}" => abspath("${path.module}/files/policies/${p}.yml")
      "${p}" => yamldecode(
        file("${path.module}/files/policies/${p}.yml")
      )
    } if lookup(local.policies[f], "customer_managed", false) != false
  ]...)
}

output "available_customer_managed_policies" {
  description = "Customer managed policy names"
  value = local.features == [] ? [] : distinct(concat([
    for f in local.features : [
      for p in lookup(local.policies[f], "available_customer_managed", []) : p
    ]
  ]...))
}
