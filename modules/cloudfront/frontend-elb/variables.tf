variable "env" {
  description = "環境変数"
}

variable "domain_name" {
  description = "ELBドメイン名"
}

variable "custom_header" {
  description = "カスタムヘッダ"
  default = [
    #{ name  = "hello", value = "world" }
  ]
}

variable "web_acl_id" {
  description = "WAF ACL ID"
  default     = null
}

variable "aliases" {
  description = "FQDN と Hosted zone ID のセット"
  default = {
    #"www.example.com" = "Z0123456789ABCDEFGHIJ"
    #"cdn.example.com" = "Z0123456789ABCDEFGHIJ"
  }
}

variable "acm_certificate_arn" {
  description = "ACM certificate arn"
}

variable "headers" {
  description = "Select the header to include in the cache key."
  default     = ["*"]
}

variable "ttl" {
  description = "Cache Min/Max/Default TTL"
  default     = 0
}

variable "log_bucket" {
  description = "ログ用S3バケット"
  default     = null
}

variable "log_prefix" {
  description = "ログ用S3プレフィックス"
  # デフォルトは aliases の先頭ドメイン名になります
  default = null
}
