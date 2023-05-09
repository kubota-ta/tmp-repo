# LambdaFunction RedisEventFilter

ElastiCache Redis の Notification をフィルタリングする LambdaFunction を作成します  
1st で使用しているものと同じため、命名規則などは例外的です


## 作られるもの

| ResourceType        | Name                                               |
|----                 |----                                                |
| IAMPolicy           | AWSLambdaBasicExecutionRole-(env.project.name)-lambda-redis-event-filter-role  |
| IAMPolicy           | AWSLambdaSNSPublishPolicyExecutionRole-(env.project.name)-lambda-redis-event-filter-role  |
| IAMRole             | (env.project.name)-lambda-redis-event-filter-role  |
| CloudWatchLogGroup  | /aws/lambda/(prefix)RedisEventFilter               |
| LambdaFunction      | (prefix)RedisEventFilter                           |


## 関連モジュール

- sns_topic
  - [modules/elasticache/base](../../elasticache/base)
