# CIDR 定義呼び出し用モジュール

ファイルのデータを引き出すためのモジュールです  
リソースの構築は一切行いません

## 定義ファイル

./files/cidr_blocks.yml

SecurityGroup や WAF で使用する CIDR 定義


./files/security_groups.yml

CIDR を用途によってグループ化するための定義


security_groups.yml のキーを入力に cidr_blocks.yml から関係する CIDR リストを取得します

