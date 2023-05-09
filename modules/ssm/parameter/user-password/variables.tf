variable "env" {
  description = "環境変数"
}

variable "key_prefix" {
  description = "キー名接頭辞"
}

variable "user" {
  description = "ユーザー名（未指定の場合は key_prefixt と同じ）"
  default     = null
}

variable "pass_length" {
  description = "パスワードの長さ"
  default     = 16
}

variable "pass_special" {
  description = "パスワードの特殊文字"
  default     = false
}
