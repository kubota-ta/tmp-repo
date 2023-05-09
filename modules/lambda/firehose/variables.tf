variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "filename" {
  description = "アップロードファイル名"
}

variable "handler" {
  description = "ハンドラ"
  default     = "index.handler"
}

variable "cloudwatch_logs_retention" {
  description = "CloudWatch Logs 保持期限"
  default     = 7
}

variable "runtime" {
  description = "runtime"
  default     = "nodejs14.x"
}

variable "architecture" {
  description = "architecture"
  default     = "x86_64"
}

variable "timeout" {
  description = "timeout"
  default     = 10
}
