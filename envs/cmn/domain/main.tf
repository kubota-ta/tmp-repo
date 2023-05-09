# 同環境内のtfstate呼び出し
module "here" {
  source   = "../modules/load"
  features = ["base"]
}

/**
 * Route53
 */
module "domain" {
  for_each = module.env.project.domain
  source   = "../../../modules/route53/public-hosted-zone"
  env      = module.env
  domain   = each.value
  comment  = each.key
}

module "private_domain" {
  for_each = {}
  source   = "../../../modules/route53/private-hosted-zone"
  env      = module.env
  domain   = each.value
  vpc_id   = module.here.data.vpc.vpc_id
  comment  = each.key
}

/**
 * リージョンリソース向け証明書
 */
module "cert-region" {
  #for_each = module.env.project.domain
  for_each = {}

  source  = "../../../modules/acm/dns"
  env     = module.env
  domain  = "*.${module.env.name}.${each.value}"
  zone_id = module.domain[each.key].hosted_zone.zone_id
}

/**
 * グローバルリソース向け証明書
 */
module "cert-global" {
  #for_each = module.env.project.domain
  for_each = {}

  providers = {
    aws = aws.global
  }

  source  = "../../../modules/acm/dns"
  env     = module.env
  domain  = "*.${module.env.name}.${each.value}"
  zone_id = module.domain[each.key].hosted_zone.zone_id
}
