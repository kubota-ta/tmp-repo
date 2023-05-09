# EC2 Instance (front サブネットインスタンス)

IAMRole(IAMInstanceProfile), EC2Instance, EIP を作成します  
front サブネットに配置されることを想定しています


## 作られるもの

| ResourceType        | Name                         |
|----                 |----                          |
| EC2Instance         | (env.prefix)-(name)          | 
| EIP                 | (env.prefix)-(name)          |
| IAMInstanceProfile  | (env.prefix)-(name)-profile  |
| IAMRole             | (env.prefix)-(name)-role     |


## 関連モジュール

- vpc_security_group_ids
  - [modules/ec2/security-group/ingress_rules](../security-group/ingress_rules)
  - [modules/ec2/security-group/self](../security-group/self)
- subnet_ids
  - [modules/vpc/vpc/multi-subnets](../../vpc/vpc/multi-subnets)
