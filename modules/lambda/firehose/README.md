# LambdaFunction for Firehose

DeliveryStream のデータ変換に使用する LambdaFunction を作成します


## 作られるもの

| ResourceType        | Name                                                    |
|----                 |----                                                     |
| IAMPolicy           | (env.prefix)-lambda-(name)-AWSLambdaBasicExecutionRole  |
| IAMRole             | (env.prefix)-lambda-(name)                              |
| CloudWatchLogGroup  | /aws/lambda/(env.prefix)-(name)                         |
| LambdaFunction      | (env.prefix)-(name)                                     |
