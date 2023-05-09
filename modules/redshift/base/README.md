# Redshift 基本リソース

Redshift の利用に共通で必要な基本リソースを作成します


## 作られるもの

| ResourceType         | Name                                                     |
|----                  |----                                                      |
| SSMParameter         | /(env.project.name)/(env.name)/redshift/master_user      |
| SSMParameter         | /(env.project.name)/(env.name)/redshift/master_password  |
| RedshiftSubnetGroup  | (env.prefix)-front                                       | 


## 関連モジュール

- subnet_ids
  - [modules/vpc/vpc/multi-subnets](../../vpc/vpc/multi-subnets)
