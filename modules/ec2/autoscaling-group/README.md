# AutoScalingGroup

AutoScalingGroup 及び LaunchTemplate を作成します  
variables に origin_id が渡されている場合 AMI の作成・管理も行います


## 作られるもの

| ResourceType      | Name                                                |
|----               |----                                                 |
| AutoScalingGroup  | (env.prefix)-(name)                                 |
| LaunchTemplate    | (env.prefix)-(name)                                 |
| AMI               | ref: [modules/ec2/ami/retention](../ami/retention)  |


## 関連モジュール

- origin_id
  - [modules/ec2/front-instance](../../front-instance)
  - [modules/ec2/web-instance](../../web-instance)
- iam_instance_profile
  - [modules/ec2/front-instance](../../front-instance)
  - [modules/ec2/web-instance](../../web-instance)
- security_groups
  - [modules/ec2/security-group/self](../security-group/self)
  - [modules/ec2/security-group/ingress_rules](../security-group/ingress_rules)
- subnet_ids
  - [modules/vpc/vpc/multi-subnets](../../vpc/vpc/multi-subnets)
- target_group_arns
  - [modules/ec2/elb/cloudfront-listener](../elb/cloudfront-listener)
