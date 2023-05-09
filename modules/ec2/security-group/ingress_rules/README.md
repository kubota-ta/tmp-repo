# SecurityGroup

SecurityGroup を作成し、接続元の CIDR に対して指定のルールを設定します


## 作られるもの

| ResourceType    | Name                         |
|----             |----                          |
| SecurityGroup   | (env.prefix)-(name)          |


## 関連モジュール

- vpc_id
  - [modules/vpc/vpc/multi-subnets](../../../vpc/vpc/multi-subnets)
- cidr_blocks
  - [envs/cmn/modules/cidr](../../../../envs/cmn/modules/cidr)


## ファイル

- rules.tf
  以下から転用
  https://github.com/terraform-aws-modules/terraform-aws-security-group/blob/master/rules.tf


## 使い方

カスタムルール
```
module "sg" {
  source = "modules/ec2/security-group/ingress_rules"

  env         = {
    prefix = "my-test"
    tags   = {
      Terraform = True
    }
  }
  name        = "trust"
  vpc_id      = "vpc-12345678"
  cidr_blocks = [
    { "cidr_block": "1.2.3.0/30",    "description": "office 1" },
    { "cidr_block": "1.2.3.128/31",  "description": "office 2" },
    { "cidr_block": "1.2.3.254/32",  "description": "office 3" }
  ]
  allow_rules = [{
    from_port = "80"
    to_port   = "80"
    protocol  = "tcp"
  }]
}
```

定義済みのルールを使う
```
module "sg" {
  source = "modules/ec2/security-group/ingress_rules"

  env         = {
    prefix = "my-test"
    tags   = {
      Terraform = True
    }
  }
  name        = "trust"
  vpc_id      = "vpc-12345678"
  cidr_blocks = jsondecode(file("./files/trust.json"))
  allow_rules = [{ rule = "http-80-tcp" }, { rule = "https-443-tcp" }]
}
```
