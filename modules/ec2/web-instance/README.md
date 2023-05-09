# EC2 Instance (web サブネットインスタンス)

IAMRole(IAMInstanceProfile), EC2Instance を作成します  
web サブネットに配置されることを想定しています


## 作られるもの

| ResourceType        | Name                         |
|----                 |----                          |
| EC2Instance         | (env.prefix)-(name)          | 
| IAMInstanceProfile  | (env.prefix)-(name)-profile  |
| IAMRole             | (env.prefix)-(name)-role     |


## 関連モジュール

- vpc_security_group_ids
  - [modules/ec2/security-group/ingress_rules](../security-group/ingress_rules)
  - [modules/ec2/security-group/self](../security-group/self)
- subnet_ids
  - [modules/vpc/vpc/multi-subnets](../../vpc/vpc/multi-subnets)
