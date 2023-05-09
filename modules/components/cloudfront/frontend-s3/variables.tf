variable "origin" {
  description = "Origin設定情報"
  #内容はマネジメントコンソールに準拠
}

variable "default_cache_behavior" {
  description = "DefaultCacheBehavior設定情報"
  #内容はマネジメントコンソールに準拠
}

variable "price_class" {
  description = "Price Class"
}

variable "web_acl_id" {
  description = "Amazon WAF Web ACL ID"
}

variable "aliases" {
  description = "Alternate domain name(CNAME)"
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN"
}

variable "ssl_support_method" {
  description = "SSL clients support"
}

variable "minimum_protocol_version" {
  description = "Security policy"
}

variable "http_version" {
  description = "Supported HTTP versions"
}

variable "default_root_object" {
  description = "Default root object"
}

variable "logging_config" {
  description = "Logging config"
}

variable "is_ipv6_enabled" {
  description = "Enable IPv6"
}

variable "comment" {
  description = "Description"
}

variable "enabled" {
  description = "Distribution State"
}

variable "tags" {
  description = "Tags"
}
