variable "env" {
  description = "環境変数"
}

variable "lambda_prefix" {
  description = "Lambda名用プレフィックス"
  default     = ""
}

variable "subnet_ids" {
  description = "プライベート用サブネットIDのリスト"
}

variable "subscription" {
  description = "サブスクリプションのリスト"
  default = {
    # "you@example.com" = "email"
  }
}
