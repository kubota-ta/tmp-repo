variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "lifecycle_rule" {
  description = "ライフサイクルルール"
  default = {
    # [prefix]   = [days],
    # elb        = 14,
    # cloudfront = 14,
  }
}
