# LaunchTemplate (front サブネットインスタンス)

LaunchTemplate を作成します
front サブネットに配置されることを想定しています


## 作られるもの

| ResourceType        | Name                         |
|----                 |----                          |
| LaunchTemplate      | (env.prefix)-(name)          |


## 関連モジュール

- iam_instance_profile
  - [modules/iam/ec2-instance-profile](../../../iam/ec2-instance-profile)
- subnet_id
  - [modules/vpc/vpc/multi-subnets](../../../vpc/vpc/multi-subnets)
- security_groups
  - [modules/ec2/security-group/ingress_rules](../../security-group/ingress_rules)
  - [modules/ec2/security-group/self](../../security-group/self)
