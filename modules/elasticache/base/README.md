# ElastiCache 基本リソース

ElastiCache の利用に共通で必要な基本リソースを作成します

## 作られるもの

| ResourceType            | Name                                                                  |
|----                     |----                                                                   |
| ElastiCacheSubnetGroup  | (env.prefix)-private                                                  |
| Lambda                  | ref: (modules/lambda/elasticache)[../../lambda/elasticache]           |
| LambdaPermission        | sns-ap-northeast-1-000000000000-redis-to-lambda                       |
| SNSTopic                | redis-to-lambda                                                       |
| SNSTopic                | (env.prefix)-elasticache-notification                                 |
| SNSTopicSubscription    | arn:aws:lambda:ap-northeast-1:000000000000:function:RedisEventFilter  |
| SNSTopicSubscription    | (subscription)                                                        |

## 関連モジュール

- subnet_ids
  - [modules/vpc/vpc/multi-subnets](../../vpc/vpc/multi-subnets)
