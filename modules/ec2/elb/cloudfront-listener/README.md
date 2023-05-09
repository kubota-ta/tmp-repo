# CloudFront オリジン用 Listener

ELB Listener を作成し、判定に従い TargetGroup へ forward するルールを追加します
入力として ELB 本体と登録するターゲットが必要です

判定項目は host と x-pre-shared-key です  
ルールに一致しない場合 (Default route) は 403 固定応答です


## 作られるもの

| ResourceType              | Name                         |
|----                       |----                          |
| ELBListener               | -                            |
|   - Rule                  | -                            |
| ELBTargetGroup            | (target_groups.key)          |
|   - Attachment            | -                            |


## 関連モジュール
- vpc_id
  - [modules/vpc/vpc/multi-subnets](../../../vpc/vpc/multi-subnets)
- target_groups(instance_ids)
  - [modules/ec2/web-instance](../../web-instance)
- listener_rules
  - [modules/cloudfront/distribution](../../../cloudfront/distribution)
  - [modules/cloudfront/frontend-elb](../../../cloudfront/frontend-elb)
  - [modules/cloudfront/frontend-s3](../../../cloudfront/frontend-s3)
- load_balancer_arn
  - [modules/ec2/elb/internet-base](../internet-base)
