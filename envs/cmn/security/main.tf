# 同環境内のtfstate呼び出し
module "cmn" {
  source   = "../../cmn/modules/load"
  features = ["base"]
}

/**
 * Security groups
 */
# 限定アクセス
locals {
  security_groups = [
    #"trust"
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
  vpc_id      = module.cmn.data.vpc.vpc_id
  cidr_blocks = each.value.cidr_blocks
  allow_rules = [{ rule = "all-all" }]
}

# パブリックHTTP
module "sg-public-http" {
  source = "../../../modules/ec2/security-group/ingress_rules"

  env         = module.env
  name        = "public-http"
  vpc_id      = module.cmn.data.vpc.vpc_id
  cidr_blocks = [{ "cidr_block" : "0.0.0.0/0" }]
  allow_rules = [{ rule = "http-80-tcp" }]
}

# パブリックWEB
module "sg-public-web" {
  source = "../../../modules/ec2/security-group/ingress_rules"

  env         = module.env
  name        = "public-web"
  vpc_id      = module.cmn.data.vpc.vpc_id
  cidr_blocks = [{ "cidr_block" : "0.0.0.0/0" }]
  allow_rules = [{ rule = "http-80-tcp" }, { rule = "https-443-tcp" }]
}

/**
 * WAF
 */
locals {
  waf_security_groups = [
    #"waf-trust"
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
    #"admin",
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