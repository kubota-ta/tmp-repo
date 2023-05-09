variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "addresses" {
  description = "許可IPAddressのリスト"
  #SecurityGroupと同じフォーマットで設定できるようにする
  #default = [
  #  { "cidr_block": "0.0.0.0/0",   "description": "all" }
  #]
}
