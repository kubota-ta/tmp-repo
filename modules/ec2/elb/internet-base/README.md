# ELB ApplicationLoadBalancer

ApplicationLoadBalancer (本体のみ) を作成します  
別途、Listener や TargetGroup の作成が必要です


## 作られるもの

| ResourceType    | Name                         |
|----             |----                          |
| LoadBalancer    | (env.prefix)-(name)          |


## 関連モジュール

- subnets
  - [modules/vpc/vpc/multi-subnets](../../../vpc/vpc/multi-subnets)
- security_groups
  - [modules/ec2/security-group/ingress_rules](../../security-group/ingress_rules)
  - [modules/ec2/security-group/self](../../security-group/self)
- log_bucket
  - [modules/s3/bucket/log-storage](../../../s3/bucket/log-storage)
