# S3 Bucket ログ格納向けバケット

ログ格納向けの Bucket を作成し、  
ELB 及び CloudFront からのログ書き込みのためのアクセス許可設定をします

指定によってライフサイクルルールの設定もします


## 作られるもの

| ResourceType     | Name                         |
|----              |----                          |
| S3Bucket         | (env.prefix)-(name)          |
