# CloudFront Distribution

CloudFront Distribution と、その Alias (Alternate domain names) の A レコードを作成します  
1つの Origin と Behavior に対応しています
複数の Origin に振り分ける場合は [../distribution](../distribution) を使用してください

※これは古いモジュールです、新しいモジュール [../distribution](../distribution) で同様の構成が作成できます


## 作られるもの

| ResourceType              | Name                         |
|----                       |----                          |
| Route53Record             | (aliases)                    |
| CloudFrontDistribution    | -                            |
|   - Origin(S3)            | (origins.key)                |
|   - DefaultCacheBehavior  | -                            |


## 関連モジュール

- origins  
  - [modules/s3/bucket/restapi-origin](../../s3/bucket/restapi-origin)
- web_acl_id
  - [modules/waf/acl-cloudfront-allow-ip](../../waf/acl-cloudfront-allow-ip)
- acm_certificate_arn
  - [modules/acm/dns](../../acm/dns)
- log_bucket
  - [modules/s3/bucket/log-storage](../../s3/bucket/log-storage)

## methodについて
CORS設定の際に、別途指定が必要な場合がありましたので、ディストリビューション別で設定できるようにしました。
--
variable "allowed_methods" {
  description = "allowed methods"
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "cached methods"
  default     = ["GET", "HEAD"]
}
--
デフォルトではもともと設定していた値が入るようになっています。
ディストリビューション別で指定したい場合は、作成のほうで
--
module "cloudfront-tellme" {
  中略
  origin_access_identity = module.s3-tellme.cloudfront_access_identity_path
  allowed_methods        = ["GET", "HEAD", "OPTIONS"]
  cached_methods         = ["GET", "HEAD", "OPTIONS"]
  #origin_path            = each.key
  origin_path            = null
　中略
}
--
上記のようにmethodを指定してください。