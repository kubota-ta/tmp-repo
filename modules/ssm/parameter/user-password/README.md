# SSM Parameter ユーザーとパスワードのセット

SSM Parameter を作成します
- user     = (user or key_prefix)
- password = (auto generated)


## 作られるもの

| ResourceType    | Name                                                  |
|----             |----                                                   |
| SSMParameter    | /(env.project.name)/(env.name)/(key_prefix)_user      |
| SSMParameter    | /(env.project.name)/(env.name)/(key_prefix)_password  |
