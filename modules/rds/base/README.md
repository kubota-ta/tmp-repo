# RDS 基本リソース

RDS の利用に共通で必要な基本リソースを作成します


## 作られるもの

| ResourceType    | Name                                               |
|----             |----                                                |
| SSMParameter    | /(env.project.name)/(env.name)/db/master_user      |
| SSMParameter    | /(env.project.name)/(env.name)/db/master_password  |
| RDSSubnetGroup  | (env.prefix)-private                               |


## 関連モジュール

- subnet_ids
  - [modules/vpc/vpc/multi-subnets](../../vpc/vpc/multi-subnets)
