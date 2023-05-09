# IAMPolicy

IAMRole のポリシー構成を入力に、カスタマーポリシーを生成し、
IAMPolicy の ARN リストを返します

ポリシー構成のデータ構造は [envs/cmn/modules/iam-role-policies](../../../envs/cmn/modules/iam-role-policies)
から取得できるものです


## 作られるもの

| ResourceType    | Name                                          |
|----             |----                                           |
| IAMPolicy       | (template.key.customer_managed_policies.key)  |


## 関連モジュール

- template
  - [envs/cmn/modules/iam-role-policies](../../../envs/cmn/modules/iam-role-policies)
