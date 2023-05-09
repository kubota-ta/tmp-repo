locals {

  output_all = [
    for v in data.terraform_remote_state.this : v.outputs
  ]

  output_keys = setunion(flatten([
    for v in local.output_all : keys(v)
  ][*]))

  output_values = {
    for k in local.output_keys : k => merge([
      for v in local.output_all : lookup(v, k, {})
    ]...)
  }
}

output "data" {
  description = "環境リソース"
  value       = local.output_values
}
