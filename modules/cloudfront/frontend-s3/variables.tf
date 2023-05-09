variable "env" {
  description = "環境変数"
}

variable "domain_name" {
  description = "S3リージョンドメイン名"
}

variable "origin_path" {
  description = "Origin path"
  default     = null
}

variable "origin_access_identity" {
  description = "Origin access identity"
}

variable "allowed_methods" {
  description = "allowed methods"
  default     = ["GET", "HEAD"]
}

variable "cached_methods" {
  description = "cached methods"
  default     = ["GET", "HEAD"]
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

variable "ttl" {
  description = "Cache Min/Max/Default TTL"
  default     = 600
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
