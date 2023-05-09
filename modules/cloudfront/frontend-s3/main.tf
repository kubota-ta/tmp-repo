/**
 * CloudFront > Distributions
 */
module "cloudfront_distribution" {
  source = "../../components/cloudfront/frontend-s3"

  ## Origin
  origin = {

    # Origin domain
    domain_name = var.domain_name

    # Origin Path
    origin_path = var.origin_path

    # Name
    origin_id = "s3"

    # S3 bucket access: Yes use OAI
    # Origin access identity
    origin_access_identity = var.origin_access_identity

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
  }

  ## Default Cache Behavior
  default_cache_behavior = {

    # Path Pattern: Default (*)

    # Compress Objects Automatically: Yes
    # https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/ServingCompressedFiles.html
    compress = true

    ## Viewer

    # Viewer Protocol Policy: Redirect HTTP to HTTPS
    viewer_protocol_policy = "redirect-to-https"

    # Allowed HTTP Methods: GET, HEAD
    allowed_methods = var.allowed_methods
    cached_methods  = var.cached_methods

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
    min_ttl     = var.ttl
    max_ttl     = var.ttl
    default_ttl = var.ttl

    ## Additional settings

    # Smooth streaming
    smooth_streaming = false

    # Field-level encryption: (skip)
    field_level_encryption_id = null

    # Enable real-time logs: No
    realtime_log_config_arn = null
  }

  ## Function associations: (skip)

  ## Settings

  # Price Class: Use all edge locations (best performance)
  price_class = "PriceClass_All"

  # Amazon WAF Web ACL
  web_acl_id = var.web_acl_id

  # Alternate domain name(CNAME)
  aliases = [
    for k, v in var.aliases : k
  ]

  # Custom SSL certificate: ACM certificate
  acm_certificate_arn = var.acm_certificate_arn

  # Legacy clients support: Enabled: No
  ssl_support_method = "sni-only"

  # Security policy
  # マネジメントコンソールのデフォルトは最新バージョンですが
  # terraform のデフォルトは TLSv1 なので注意
  minimum_protocol_version = "TLSv1.2_2021"

  # Supported HTTP versions: HTTP/2: Yes
  http_version = "http2"

  # Default root object: (skip)
  default_root_object = null

  # Standard logging: Off
  logging_config = var.log_bucket == null ? null : {
    # S3 bucket
    bucket = "${var.log_bucket}.s3.amazonaws.com"
    # Log prefix
    prefix = var.log_prefix == null ? "cloudfront/${keys(var.aliases)[0]}" : "cloudfront/${var.log_prefix}"
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
  for_each = var.aliases

  zone_id = each.value
  name    = each.key
  type    = "A"

  alias {
    zone_id                = module.cloudfront_distribution.distribution.hosted_zone_id
    name                   = module.cloudfront_distribution.distribution.domain_name
    evaluate_target_health = false
  }
}

