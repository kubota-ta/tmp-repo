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
