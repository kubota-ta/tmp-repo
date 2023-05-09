# DocumentDB Cluster 4.0

EngineVersion 4.0 の DocumentDB Cluster とその ParameterGroup を作成します


## 作られるもの

| ResourceType              | Name                                    |
|----                       |----                                     |
| DocumentDBParameterGroup  | (env.prefix)-(name)                     |
| DocumentDBCluster         | (env.prefix)-(name)                     |
| DocumentDBInstance        | (env.prefix)-(name)-(db_instances.key)  |


## 関連モジュール

- db_subnet_group_name
  - [modules/docdb/base](../base)
- master_username
  - [modules/docdb/base](../base)
- master_password
  - [modules/docdb/base](../base)
- vpc_security_group_ids
  - [modules/ec2/security-group/self](../../ec2/security-group/self)rity-group/self)
