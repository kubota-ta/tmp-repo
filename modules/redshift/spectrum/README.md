# Redshift Spectrum

S3 で利用する Redshift Cluster を作成します


## 作られるもの

| ResourceType                   | Name                 |
|----                            |----                  |
| IAMRole                        | (env.prefix)-(name)  |
| RedshiftClusterParameterGroup  | (env.prefix)-(name)  |
| RedshiftCluster                | (env.prefix)-(name)  |


## 関連モジュール

- master_username
  - [modules/redshift/base](../base)
- master_password
  - [modules/redshift/base](../base)
- security_group_ids
  - [modules/ec2/security-group/ingress_rules](../../ec2/security-group/ingress_rules)
  - [modules/ec2/security-group/self](../../ec2/security-group/self)
- cluster_subnet_group_name
  - [modules/redshift/base](../base)
