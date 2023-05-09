variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "subnets" {
  description = "サブネットIDのリスト"
}

variable "security_groups" {
  description = "セキュリティグループIDのリスト"
}

variable "idle_timeout" {
  description = "Idle timeout"
  default     = 60
}

variable "log_bucket" {
  description = "ログ用S3バケット"
  default     = null
}
