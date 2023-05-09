# AWSインフラ構成 - グローバル モジュールテンプレート＆サンドボックス

AWS環境を構成するTerraformプロジェクトです。  
このプロジェクトの modules は  
全てのプロジェクトの初期ソースとなります。  
派生プロジェクトで発生した修正はここへフィードバックし、
このプロジェクトの modules が最新となるように維持します。
```
global-terraform -- copy --> (project)-terraform  
    ^                              |
    |                              v
    +---- feedback ----------------+
```


## 要件

- [terraform](https://www.terraform.io/)
- [terragrunt](https://terragrunt.gruntwork.io/)

各サイトから直接実行ファイルを取得するか  
スクリプトを使用して取得します。

スクリプト使用例
```
sh bin/get-terraform.sh
mv bin/terraform path/to/bindir/
sh bin/get-terragrunt.sh
mv bin/terragrunt path/to/bindir/
```


## 構成

```
./
  bin/                  補助スクリプトなど
  envs/
    [env]/              環境ディレクトリ（terragrunt run-allでの実行単位）
      [feature]/        機能ディレクトリ（terraformでの実行単位）
      modules/          環境間でデータの仲介をするモジュール群
  modules/
    components/         モジュール内で使用するモジュール群
    [aws service/.../feature]/
                        主体となるリソースのサービス名で適当にディレクトリ分割

  #以下は検証用の構成であり、プロジェクト用リポジトリには必要ありません
  sandbox/              検証用のenvs
                        詳細は [README.md](./sandbox/README.md) 参照
```

## 使い方

envs/[env]/[feature]/ に遷移して terragrunt コマンドを実行  
あるいは  
envs/[env]/ に遷移して terragrunt run-all コマンドを実行します

```bash
#個別実行
cd envs/cmn/base/
terragrunt init
terragrunt plan
terragrunt apply

#一括実行
cd envs/cmn/
terragrunt run-all init
terragrunt run-all plan
terragrunt run-all apply
```
terragrunt 実行時に、自動生成ファイル terragrunt-*.tf が生成されます  
それらのファイルがある状態では terraform コマンドでの実行も可能です


## 事前準備（実行権限設定）

下記で作成するIAMリソースは CloudFormation で作成できます  
- SourceFile: [cf-terraform-role.yml](/projects/II_DIV/repos/global-terraform/browse/sandbox/stub/935762823806/files/cloudformation/cf-terraform-role.yml)
- S3URL:  s3://ginfra-stub-work/cloudformation/cf-terraform-role.yml
- Parameters:
	- MyName: (変更なし)
	- MyTrustAWS: (変更なし - インフラの検証環境のIDが入っています)
	- MyExternalId: (任意のランダム文字列を生成して入力)
- AccessPolicy:
	- [s3_bucket.tf](/projects/II_DIV/repos/global-terraform/browse/sandbox/stub/935762823806/s3_bucket.tf) の `data.aws_iam_policy_document.s3-infra-work` に AWS ID を追記し `terraform apply`


### 構築側のAWS環境

実行時に使用するIAMRoleの作成
1. IAM > Roles > [Create role]
	1. Select type of trusted entity: Another AWS account
		- Account ID: 000000000000
		- Options: Require external ID: xxxxxxxx
	1. Attach permissions policies
		- AdministratorAccess
	1. Add tags
		- Name: infra-terraform-role
	1. Role name
		- infra-terraform-role


### 操作側のAWS環境

前述のIAMRoleのAssumeRoleポリシーの作成
1. IAM > Policies > [Create Policy]
	1. A policy defines
		- JSON: (後述)
	1. Add tags
		- None
	1. Review policy
		- Name: infra-terraform-AssumeRole
		- Description:  Policy for access terraform role
	1. 実行サーバーに適宜アタッチする

JSON:
```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Resource": "arn:aws:iam::999999999999:role/infra-terraform-role",
            "Effect": "Allow"
        }
    ]
}
```


実行サーバーにログインし、~/.aws/config を編集する
```
[profile prj-terraform]
role_arn = arn:aws:iam::999999999999:role/infra-terraform-role
external_id = xxxxxxxx
```
envs/terragrunt-config.hcl の aws_profile を修正する


## 事前準備（事前に必要なリソースの作成）

1. 必要リソースを作成する
	- envs/_pre が使えます [README参照](./envs/_pre/README.md)


## 実行順番（依存関係）について

環境内の機能同士の依存関係については envs/[env]/[feature]/terragrunt.hcl に記載されます
基本的には cmn 以外はお互いに依存しないように作ります

実行する順番

1. envs/_pre
1. envs/cmn/base
1. envs/cmn/(other)
1. envs/(other)

