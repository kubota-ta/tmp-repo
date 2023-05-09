variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "s3_bucket" {
  description = "S3バケット名"
}

variable "s3_prefix" {
  description = "ログプレフィックス"
}

variable "s3_error_prefix" {
  description = "エラー出力プレフィックス"
}

variable "lambda_function" {
  description = "lambda 関数名"
  default     = null
}

variable "buffer_size" {
  description = "Buffer size"
  default     = 5
}

variable "buffer_interval" {
  description = "Buffer interval"
  default     = 300
}

variable "cloudwatch_logs_retention" {
  description = "Cloudwatch Logs Retention"
  default     = 7
}
