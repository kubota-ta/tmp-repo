# SystemsManager MaintenanceWindow Windows 自動アップデート

対象のサーバーに定期的に WindowsUpdate を実行する MaintenanceWindow を作成します
- SSMWindowsUpdate = true のタグを持つサーバーを対象に定期アップデートを実行する
- 起動中であればアップデートのみ  
停止中であれば 起動 -> アップデート -> 停止 を行う
- ターゲットのリストアップは、SSMの処理実行時ではなく、構築時(terraform apply 時)に行っているため  
ターゲットを変更する場合は再構築が必要です  
(単純にタグをターゲットの設定にすると、停止中のインスタンスが対象外になるため)


## 作られるもの

| ResourceType          | Name                                  |
|----                   |----                                   |
| IAMRole               | (env.prefix)-AmazonSSMAutomationRole  |
| SSMDocument           | (env.prefix)-InstallWindowsUpdates    |
| SSMMaintenanceWindow  | (env.prefix)-InstallWindowsUpdates    |
|   - Target            | SSMWindowsUpdate                      |
|   - Task              | InstallWindowsUpdates                 |
