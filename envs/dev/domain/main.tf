/**
 * リージョンリソース向け証明書
 */
module "cert-region" {
  #for_each = module.env.project.domain
  for_each = {}

  source  = "../../../modules/acm/dns"
  env     = module.env
  domain  = "*.${module.env.name}.${each.value}"
  zone_id = module.env.cmn.hosted_zone[each.key]
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
  zone_id = module.env.cmn.hosted_zone[each.key]
}
