# RDS Aurora 2 (MySQL 5.7)

EngineVersion Aurora 2 (MySQL 5.7) の RDS DBCluster/DBInstance とその ParameterGroup を作成します


## 作られるもの

| ResourceType              | Name                                    |
|----                       |----                                     |
| DBClusterParameterGroup   | (env.prefix)-(name)-cluster             |
| DBParameterGroup          | (env.prefix)-(name)                     |
| DBCluster                 | (env.prefix)-(name)                     |
| DBInstance                | (env.prefix)-(name)-(db_instances.key)  |


## 関連モジュール

- db_subnet_group_name
  - [modules/rds/base](../base) 
- master_username
  - [modules/rds/base](../base)
- master_password
  - [modules/rds/base](../base)
- vpc_security_group_ids
  - [modules/ec2/security-group/self](../../ec2/security-group/self)
