output "hosted_zone" {
  value = {
    for k, v in module.domain : k => v.hosted_zone.zone_id
  }
}

output "private_hosted_zone" {
  value = {
    for k, v in module.private_domain : k => v.hosted_zone.zone_id
  }
}

output "cert-region" {
  description = "リージョンリソース向け証明書"
  value = {
    for k, v in module.cert-region : k => v.cert.arn
  }
}

output "cert-global" {
  description = "グローバルリソース向け証明書"
  value = {
    for k, v in module.cert-global : k => v.cert.arn
  }
}

