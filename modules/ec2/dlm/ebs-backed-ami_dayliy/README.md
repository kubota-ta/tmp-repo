# DataLifecycleManager LifecyclePolicy (EBS-backed AMI policy)

EBS-backed AMI policy を作成します


## 作られるもの

| ResourceType      | Name                         |
|----               |----                          |
| LifecyclePolicy   | (env.prefix)-(name)          |


## 関連モジュール

- iam_role
  - [modules/ec2/dlm/base](../base)
