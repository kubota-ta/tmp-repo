# CloudFront Distribution

CloudFront Distribution と、その Alias (Alternate domain names) の A レコードを作成します  
Origin (ELB) の Listener 条件の為の x-pre-shared-key の値も生成します  
1つの Origin と Behavior に対応しています  
複数の Origin に振り分ける場合は [../distribution](../distribution) を使用してください

※これは古いモジュールです、新しいモジュール [../distribution](../distribution) で同様の構成が作成できます


## 作られるもの

| ResourceType              | Name                         |
|----                       |----                          |
| Route53Record             | (aliases)                    |
| CloudFrontDistribution    | -                            |
|   - Origin(ELB)           | (origins.key)                |
|     - CustomHeader        | x-pre-shared-key             |
|   - DefaultCacheBehavior  | -                            |


## 関連モジュール

- origins  
  - [modules/ec2/elb/internet-base](../../ec2/elb/internet-base)
- web_acl_id
  - [modules/waf/acl-cloudfront-allow-ip](../../waf/acl-cloudfront-allow-ip)
- acm_certificate_arn
  - [modules/acm/dns](../../acm/dns)
- log_bucket
  - [modules/s3/bucket/log-storage](../../s3/bucket/log-storage)
