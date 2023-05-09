# IAMRole + IAMInstanceProfile

EC2 に設定する InstanceProfile を作成します  
共通で必要な Policy のアタッチもします


## 作られるもの

| ResourceType        | Name                         |
|----                 |----                          |
| IAMRole             | (env.prefix)-(name)-role     |
| IAMInstanceProfile  | (env.prefix)-(name)-profile  | 
