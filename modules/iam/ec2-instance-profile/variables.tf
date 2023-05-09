variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "policy_arns" {
  description = "追加のポリシー"
  default     = []
}

