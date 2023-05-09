variable "env" {
  description = "環境変数"
}

variable "origins" {
  description = "Origins list"
  default = {
    ## ELB
    #"elb-ex" = {  # origin_id
    #
    #(Required)
    #  type        = "elb"
    #  domain_name = "ex.ap-northeast-1.elb.amazonaws.com"
    #  
    #(Optional)
    #  origin_path = "/"
    #  custom_header = [{ name = "foo", value = "bar" }]
    #},

    ## S3
    #"s3-ex" = {  # origin_id
    #
    #(Required)
    #  type        = "s3"
    #  domain_name = "ex.s3.ap-northeast-1.amazonaws.com"
    #  origin_access_identity = "origin-access-identity/cloudfront/ABCDEFG1234567"
    #
    #(Optional)
    #  origin_path = "/"
    #},
  }
}

variable "behaviors" {
  description = "Behaviors list"
  default = {

    ## S3
    #0 = {  # Precedence(0,1,..) or "default"
    #
    #(Required)
    #  origin = "s3-ex"  # origin_id
    #
    #(Optional)
    #  path   = "img/*"
    #  ttl    = 600  # default: 600
    #
    #}

    ## ELB
    #default = {  # Precedence(0,1,..) or "default"
    #
    #(Required)
    #  origin = "elb-ex"  # origin_id
    #
    #(Optional)
    #  path   = "app/*"   # default: *
    #
    #}
  }
}

variable "aliases" {
  description = "Aliases list"
  default     = []
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
  default     = null
}

variable "web_acl_id" {
  description = "WAF ACL ID"
  default     = null
}

variable "acm_certificate_arn" {
  description = "ACM certificate arn"
  default     = null
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
