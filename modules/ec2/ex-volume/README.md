# EBS 拡張ボリューム

EBS ボリュームを作成して EC2 インスタンスにアタッチします

参考
- https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-using-volumes.html


## 作られるもの

| ResourceType    | Name                            |
|----             |----                             |
| Volume          | (instance_id.tags.Name)-(name)  |


## 関連モジュール

- instance_id
  - [modules/ec2/front-instance](../front-instance)
  - [modules/ec2/web-instance](../web-instance)
  - [modules/ec2/private-instance](../private-instance)
