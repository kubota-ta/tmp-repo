# S3 Bucket ファイルサーバ的用途用ストレージ

ファイル共有ストレージとしてオフィスPCから接続する為の Bucket を作成します  
共用の IAMUser を作成し、アクセスユーザを限定しています

- パブリックアクセスなし
- バージョニングなし
- 暗号化なし
- オブジェクトロックなし
- ライフサイクルなし


## 作られるもの

| ResourceType     | Name                         |
|----              |----                          |
| IAMUser          | (env.prefix)-(name)-rw       |
|  - InlinePolicy  | allow-ip-address             |
|  - InlinePolicy  | bucket-access                |
| S3Bucket         | (env.prefix)-(name)          |


## 関連モジュール

- allow_cidr_blocks
  - [../../../../envs/cmn/modules/cidr](../../../../envs/cmn/modules/cidr)
