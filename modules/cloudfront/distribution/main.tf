locals {
  behaviors = {
    for k, v in var.behaviors :
    k => merge(v, { "type" = lookup(var.origins, v.origin, null).type })
  }
}

## for ELB origin: カスタムヘッダ値生成
resource "random_password" "x-pre-shared-key" {
  for_each = {
    for k, v in var.origins : k => v if v.type == "elb"
  }
  length  = 16
  special = false
}


## for S3 origin: Notiong TODO


## for ALL
/**
 * CloudFront > Distributions
 */
module "cloudfront_distribution" {
  source = "../../components/cloudfront/distribution"

  ## Origin
  origins = concat([

    ## for ELB origin
    for k, v in var.origins : {

      # Origin domain
      domain_name = v.domain_name

      # Protocol
      origin_protocol_policy = "http-only"

      # HTTP Port
      http_port = 80

      # HTTPS Port
      https_port = 443

      # Minimum Origin SSL Protocol
      origin_ssl_protocols = ["TLSv1.2"]

      # Origin Path
      origin_path = lookup(v, "origin_path", null)

      # Name
      origin_id = k

      # Add custom header
      custom_header = concat(
        [{
          name  = "x-pre-shared-key"
          value = random_password.x-pre-shared-key[k].result
        }],
        lookup(v, "custom_header", [])
      )

      # Enable Origin Shield: No
      origin_shield = {
        enabled              = false
        origin_shield_region = "ap-northeast-1"
      }

      ## Additional settings
      # Connection tttempts
      connection_attempts = 3

      # Connection timeout
      connection_timeout = 10

      # Response timeout
      origin_read_timeout = 60

      # Keep-alive timeout
      origin_keepalive_timeout = 60

    } if v.type == "elb"
    ], [

    ## for S3 origin
    for k, v in var.origins : {

      # Origin domain
      domain_name = v.domain_name

      # Origin Path
      origin_path = lookup(v, "origin_path", null)

      # Name
      origin_id = k

      # S3 bucket access: Yes use OAI
      # Origin access identity
      origin_access_identity = v.origin_access_identity

      # Bucket policy: No, I will update the bucket policy

      # Add custom header
      # skip

      # Enable Origin Shield: No
      origin_shield = {
        enabled              = false
        origin_shield_region = "ap-northeast-1"
      }

      ## Additional settings
      # Connection tttempts
      connection_attempts = 3

      # Connection timeout
      connection_timeout = 10

    } if v.type == "s3"
  ])

  ## Cache Behavior
  behaviors = merge({

    # for ELB
    for k, v in local.behaviors : k => {
      target_origin_id = v.origin

      # Path Pattern: Default (*)
      path = lookup(v, "path", "*")

      # Compress Objects Automatically: No
      # 要確認：S3オリジンCDNでは使っていいのでは？
      # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ServingCompressedFiles.html
      compress = false

      ## Viewer

      # Viewer Protocol Policy: Redirect HTTP to HTTPS
      viewer_protocol_policy = "redirect-to-https"

      # Allowed HTTP Methods: GET, HEAD, OPTIONS, PUT, POST, PATCH, DELETE
      allowed_methods = ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"]

      # Cache HTTP methods: OPTIONS: No
      cached_methods = ["GET", "HEAD"]

      # Restrict Viewer Access: No
      restrictions = {
        #利用予定がないので未対応
        #geo_restriction = {
        #  restriction_type = "whitelist"
        #  locations = [ "JP" ]
        #}
      }

      ## Cache key and origin requests

      # Cache policy and origin request policy (recommended): CachingDisabled
      # こちらはカスタムヘッダを転送してくれなかったためNG（不具合?）

      # Legacy cache settings

      # Headers: All
      headers = ["*"]

      # Query strings: All
      query_string            = true
      query_string_cache_keys = []

      # Cookies: All
      cookies = {
        forward           = "all"
        whitelisted_names = []
      }

      # Object caching: Customize
      min_ttl     = 0
      max_ttl     = 0
      default_ttl = 0

      ## Additional settings

      # Smooth streaming
      smooth_streaming = false

      # Field-level encryption: (skip)
      field_level_encryption_id = null

      # Enable real-time logs: No
      realtime_log_config_arn = null

    } if v.type == "elb"
    }, {

    # for S3
    for k, v in local.behaviors : k => {
      target_origin_id = v.origin

      # Path Pattern: Default (*)
      path_pattern = lookup(v, "path", "*")

      # Compress Objects Automatically: Yes
      # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ServingCompressedFiles.html
      compress = true

      ## Viewer

      # Viewer Protocol Policy: Redirect HTTP to HTTPS
      viewer_protocol_policy = "redirect-to-https"

      # Allowed HTTP Methods: GET, HEAD
      allowed_methods = ["GET", "HEAD"]
      cached_methods  = ["GET", "HEAD"]

      # Restrict Viewer Access: No
      restrictions = {
        #利用予定がないので未対応
        #geo_restriction = {
        #  restriction_type = "whitelist"
        #  locations = [ "JP" ]
        #}
      }

      ## Cache key and origin requests

      # Cache policy and origin request policy (recommended): CachingDisabled
      # こちらはカスタムヘッダを転送してくれなかったためNG（不具合?）

      # Legacy cache settings

      # Headers: Include the follwing headers
      #  - forwarded Header Name * that is not allowed by S3.
      headers = ["Origin"]

      # Query strings: All
      query_string            = true
      query_string_cache_keys = []

      # Cookies: None
      cookies = {
        forward           = "none"
        whitelisted_names = []
      }

      # Object caching: Customize
      min_ttl     = lookup(v, "ttl", 600)
      max_ttl     = lookup(v, "ttl", 600)
      default_ttl = lookup(v, "ttl", 600)

      ## Additional settings

      # Smooth streaming
      smooth_streaming = false

      # Field-level encryption: (skip)
      field_level_encryption_id = null

      # Enable real-time logs: No
      realtime_log_config_arn = null

    } if v.type == "s3"
  })

  ## Function associations: (skip)

  ## Settings

  # Price Class: Use all edge locations (best performance)
  price_class = "PriceClass_All"

  # Amazon WAF Web ACL
  web_acl_id = var.web_acl_id

  # Alternate domain name(CNAME)
  aliases = var.aliases

  # Custom SSL certificate: ACM certificate
  acm_certificate_arn = var.acm_certificate_arn

  # Legacy clients support: Enabled: No
  ssl_support_method = var.acm_certificate_arn != null ? "sni-only" : null

  # Security policy
  # マネジメントコンソールのデフォルトは最新バージョンですが
  # terraform のデフォルトは TLSv1 なので注意
  minimum_protocol_version = var.acm_certificate_arn != null ? "TLSv1.2_2021" : null

  # Supported HTTP versions: HTTP/2: Yes
  http_version = "http2"

  # Default root object: (skip)
  default_root_object = null

  # Standard logging: Off
  logging_config = var.log_bucket == null ? null : {
    # S3 bucket
    bucket = "${var.log_bucket}.s3.amazonaws.com"
    # Log prefix
    prefix = var.log_prefix == null ? "cloudfront/${var.aliases[0]}" : "cloudfront/${var.log_prefix}"
    # Cookie logging
    include_cookies = false
  }

  # Enable IPv6: Off
  is_ipv6_enabled = false

  # Description
  comment = null

  # Distribution State: Enabled
  enabled = true

  ## Distributions > [Created Distribution]

  # Tags
  tags = var.env.tags
}

/**
 * Route53 > Hosted zones > [Hosted zone]
 */
resource "aws_route53_record" "this" {
  for_each = toset(var.aliases)

  zone_id = var.hosted_zone_id
  name    = each.key
  type    = "A"

  alias {
    zone_id                = module.cloudfront_distribution.distribution.hosted_zone_id
    name                   = module.cloudfront_distribution.distribution.domain_name
    evaluate_target_health = false
  }
}

