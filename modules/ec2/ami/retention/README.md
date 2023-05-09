# EC2 AMI

指定のインスタンスから AMI を作成し、世代管理をします  
保持判定は件数ではなくインデックス番号 (tag:TerraformAMIIndex の値) をチェックしています
```
ami_index                        new create  なければ作成
ami_index - n                    existing
  :                                :
ami_index - (ami_retention - 1)  existing    ここまでキープ (番号に抜けがなければ ami_retention 件保持される)
ami_index - ami_retention        destroy     これより小さい番号は削除対象
```


## 作られるもの

| ResourceType    | Name                              |
|----             |----                               |
| AMI             | (origin.tags.Name)_YYYYMMDD-hhmm  |


## 関連モジュール

- origin_id
  - [modules/ec2/front-instance](../../front-instance)
  - [modules/ec2/web-instance](../../web-instance)
  - [modules/ec2/private-instance](../../private-instance)
