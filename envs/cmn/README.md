# プロジェクト内で共通で利用する構成


## ファイル構成

```
./
  base/         基本構成
  domain/       ドメイン関係
  security/     ファイアウォール関係

  env.tf 	構成環境内で共通の定義

```
##　各リソース作成用
※必要に応じてコピーして利用してください
　https://confl.arms.dmm.com/pages/viewpage.action?pageId=1110077884
　上記を参考にし、必要事項を修正のうえ、利用してください。
　terragrunt initする際は、terragrunt init --upgradeを実施してください。
```
./
  frontend01            CloudFront+ELB作成用
  frontdne01-listener   上記のELBのターゲットグループ、リスナー、インスタンスのアタッチ用
  admin01             EC2インスタンス作成用
```
admin01は、必要に応じて名前を変えて利用してください