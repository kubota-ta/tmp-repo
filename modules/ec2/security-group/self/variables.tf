variable "env" {
  description = "環境変数"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "name" {
  description = "セキュリティグループ名"
  default     = "local"
}
