# SecurityGroup

SecurityGroup を作成し、接続元 = 自身の SecurityGroupID のアクセスを許可します


## 作られるもの

| ResourceType    | Name                         |
|----             |----                          |
| SecurityGroup   | (env.prefix)-(name)          |


## 関連モジュール

- vpc_id
  - [modules/vpc/vpc/multi-subnets](../../../vpc/vpc/multi-subnets)
