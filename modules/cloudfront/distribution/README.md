# CloudFront Distribution

CloudFront Distribution と Route53 Aレコード(alias) の生成を行います  
Origin に ELB を設定した場合は ELB Listener で判定に使用する為の Header (x-pre-shared-key) も生成します  
複数の Origin と Behavior (Path pattern による振り分け) に対応しています


## 作られるもの

| ResourceType              | Name                         |
|----                       |----                          |
| Route53Record             | (aliases)                    |
| CloudFrontDistribution    | -                            |
|   - Origin(ELB)           | (origins.key)                |
|     - CustomHeader        | x-pre-shared-key             |
|   - Origin(S3)            | (origins.key)                |
|   - DefaultCacheBehavior  | -                            |
|   - OrderdCacheBehavior   | -                            |


## 関連モジュール

- origins  
  - [modules/ec2/elb/internet-base](../../ec2/elb/internet-base)
  - [modules/s3/bucket/restapi-origin](../../s3/bucket/restapi-origin)
- web_acl_id
  - [modules/waf/acl-cloudfront-allow-ip](../../waf/acl-cloudfront-allow-ip)
- acm_certificate_arn
  - [modules/acm/dns](../../acm/dns)
- log_bucket
  - [modules/s3/bucket/log-storage](../../s3/bucket/log-storage)
