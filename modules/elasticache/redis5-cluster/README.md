# ElastiCache Redis Cluster 5.x

EngineVersion 5.x の Redis Cluster (ReplicationGroup) とその ParameterGroup を作成します  
Cluster mode は Enabled です


## 作られるもの

| ResourceType                 | Name                                    |
|----                          |----                                     |
| ElastiCacheParameterGroup    | (env.prefix)-(name)-cluster                     |
| ElastiCacheReplicationGroup  | (env.prefix)-(name)                     |


## 関連モジュール

- subnet_group_name
  - [modules/elasticache/base](../base)
- security_group_ids
  - [modules/ec2/security-group/self](../../ec2/security-group/self)
- notification_topic_arn
  - [modules/elasticache/base](../base)
