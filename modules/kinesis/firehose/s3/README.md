# KinesisFirehose DeliveryStream to S3

S3 宛ての DeliveryStream を作成します  
関連して必要な IAM 及び CloudWatch Log のリソースも作成します


## 作られるもの

| ResourceType         | Name                                                     |
|----                  |----                                                      |
| DeliveryStream       | (env.prefix)-(name)                                      |
| IAMRole              | (env.prefix)-firehose-(name)                             |
| IAMPolicy            | (env.prefix)-firehose-(name)-KinesisFirehoseServiceRole  |
| CloudWatchLogGroup   | /aws/kinesisfirehose/(env.prefix)-(name)                 |
| CloudWatchLogStream  | DestinationDelivery                                      |
| CloudWatchLogStream  | BackupDelivery                                           |


## 関連モジュール

- s3_bucket
  - [modules/s3/bucket/log-storage](../../../s3/bucket/log-storage) 
- lambda_function
  - [modules/lambda/firehose](../../../lambda/firehose) 
