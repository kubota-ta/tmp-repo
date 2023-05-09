variable "env" {
  description = "環境変数"
}

variable "prefix" {
  description = "名前プレフィックス"
  default     = ""
}

variable "sns_topic" {
  description = "SNS Topic arn"
}
