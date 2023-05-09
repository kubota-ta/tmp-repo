variable "env" {
  description = "環境変数"
}

variable "instance_tags" {
  description = "ターゲットのインスタンスに付与されているタグ"
  default = {
    SSMWindowsUpdate = "true"
  }
}
