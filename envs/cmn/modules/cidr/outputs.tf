locals {

  cidr_blocks     = yamldecode(file("${path.module}/files/cidr_blocks.yml"))
  security_groups = yamldecode(file("${path.module}/files/security_groups.yml"))

}

output "cidr_blocks" {
  description = "CIDR block リスト"
  value = flatten([
    for group in local.security_groups[var.security_group] : [
      for k, v in local.cidr_blocks[group] : v
    ]
  ])
}
