# プロジェクト構成

環境ディレクトリ


## ファイル構成

```
./
  terragrunt-config.hcl カスタム設定
  terragrunt.hcl        共通設定ファイル（各個別設定からインクルード）
  terragrunt-project.tf プロジェクト定義

  [env]/
    env.tf              環境定義

    [feature]/
      terragrunt.hcl                個別設定ファイル
      terragrunt-backend.tf         バックエンド設定
      terragrunt-provider.tf        プロバイダ設定
      terragrunt-requirements.tf    要求バージョン設定
      terragrunt-load.tf            環境定義呼び出し

      main.tf           構築処理
      variables.tf      変数定義
      outputs.tf        出力定義

  cmn/                  環境共通構成
  dev/                  開発環境
  :                     ;

  _pre/                 事前準備（独立）
```


