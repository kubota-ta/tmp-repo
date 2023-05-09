# AWS Certificate Manager

DNS認証で証明書をリクエストします  
デフォルトリージョン以外でリクエストする場合は  
そのリージョンのプロバイダを渡します


## 作られるもの

| ResourceType    | Name                         |
|----             |----                          |
| ACMCertificate  | (domain)                     |
| Route53Record   | (token).(domain)             |


## 関連モジュール

- zone_id
  - [modules/route53/public-hosted-zone](../../route53/public-hosted-zone)
