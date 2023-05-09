# WAF for CloudFront

CloudFront用の WAF を作成し、指定の CIDR のみを許可する設定を行います


## 作られるもの

| ResourceType    | Name                         |
|----             |----                          |
| WAFIPSet        | (env.prefix)-(name)          |
| WAFACL          | (env.prefix)-(name)          |


## 関連モジュール

- addresses
  - [../../../envs/cmn/modules](../../../envs/cmn/modules/cidr)
