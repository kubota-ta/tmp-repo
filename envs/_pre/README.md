# 事前処理

同リポジトリの terraform コードを実行する上で必要な準備をします

1. このディレクトリへ移動
1. 共通設定ファイルを修正
1. terragrunt を実行

```
cd envs/_pre
vi ../terragrunt-config.hcl
terragrunt init
terragrunt plan
terragrunt apply
```

実行内容：
- tfstate管理用バケット の作成
- EC2へのアクセスに共通で利用するキーペア の登録

