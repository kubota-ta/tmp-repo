# DataLifecycleManager 基本リソース

DataLifecycleManager の利用に共通で必要な基本リソースを作成します


## 作られるもの

| ResourceType    | Name                                                             |
|----             |----                                                              |
| IAMPolicy       | (env.prefix)-AWSDataLifecycleManagerServiceRole                  |
| IAMPolicy       | (env.prefix)-AWSDataLifecycleManagerServiceRoleForAMIManagement  |
| IAMRole         | (env.prefix)-AWSDataLifecycleManagerDefaultRole                  |
| IAMRole         | (env.prefix)-AWSDataLifecycleManagerDefaultRoleForAMIManagement  |
