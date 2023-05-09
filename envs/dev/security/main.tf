/**
 * Security groups
 */
# 限定アクセス
locals {
  security_groups = [
    #"trust",
    #"trust-system",
  ]
}
module "sg-trust_cidr-blocks" {
  for_each = toset(local.security_groups)
  source   = "../../cmn/modules/cidr"

  security_group = each.key
}
module "sg-trust" {
  for_each = module.sg-trust_cidr-blocks
  source   = "../../../modules/ec2/security-group/ingress_rules"

  env         = module.env
  name        = each.key
  vpc_id      = module.env.cmn.vpc.vpc_id
  cidr_blocks = each.value.cidr_blocks
  allow_rules = [{ rule = "all-all" }]
}

/**
 * WAF
 */
locals {
  waf_security_groups = [
    #"waf-trust",
    #"waf-trust-system",
  ]
}
module "waf-trust_cidr-blocks" {
  for_each = toset(local.waf_security_groups)
  source   = "../../cmn/modules/cidr"

  security_group = each.key
}
module "waf-trust" {
  for_each = module.waf-trust_cidr-blocks
  source   = "../../../modules/waf/acl-cloudfront-allow-ip"

  providers = {
    aws = aws.global
  }

  env       = module.env
  name      = each.key
  addresses = each.value.cidr_blocks
}

/**
 * IAM Policy
 */
module "iam-role-policies_template" {
  for_each = toset([
    #"web",
  ])
  source   = "../../cmn/modules/iam-role-policies"
  use_case = each.key
}
module "iam-role-policies" {
  source        = "../../../modules/iam/iam-policy_from-template"
  env           = module.env
  template      = module.iam-role-policies_template
  template_vars = {}
}
