/**
 * CloudFront > Distributions
 */
resource "aws_cloudfront_distribution" "this" {

  origin {
    domain_name = var.origin.domain_name
    origin_path = var.origin.origin_path

    dynamic "origin_shield" {
      for_each = var.origin.origin_shield.enabled == true ? [1] : []
      content {
        enabled              = origin_shield.enabled
        origin_shield_region = origin_shield.origin_shield_region
      }
    }

    origin_id           = var.origin.origin_id
    connection_attempts = var.origin.connection_attempts
    connection_timeout  = var.origin.connection_timeout

    s3_origin_config {
      origin_access_identity = var.origin.origin_access_identity
    }
  }

  default_cache_behavior {
    target_origin_id = var.origin.origin_id

    viewer_protocol_policy = var.default_cache_behavior.viewer_protocol_policy
    allowed_methods        = var.default_cache_behavior.allowed_methods
    cached_methods         = var.default_cache_behavior.cached_methods

    field_level_encryption_id = var.default_cache_behavior.field_level_encryption_id

    forwarded_values {
      headers = var.default_cache_behavior.headers
      cookies {
        forward           = var.default_cache_behavior.cookies.forward
        whitelisted_names = var.default_cache_behavior.cookies.whitelisted_names
      }
      query_string            = var.default_cache_behavior.query_string
      query_string_cache_keys = var.default_cache_behavior.query_string_cache_keys
    }

    smooth_streaming = var.default_cache_behavior.smooth_streaming
    compress         = var.default_cache_behavior.compress

    #function_association {}
    #未対応

    realtime_log_config_arn = var.default_cache_behavior.realtime_log_config_arn

    min_ttl     = var.default_cache_behavior.min_ttl
    max_ttl     = var.default_cache_behavior.max_ttl
    default_ttl = var.default_cache_behavior.default_ttl
  }

  restrictions {
    #未対応
    geo_restriction {
      restriction_type = "none"
    }
  }

  price_class = var.price_class
  web_acl_id  = var.web_acl_id
  aliases     = var.aliases
  viewer_certificate {
    cloudfront_default_certificate = var.acm_certificate_arn != null ? false : true
    acm_certificate_arn            = var.acm_certificate_arn
    ssl_support_method             = var.ssl_support_method
    minimum_protocol_version       = var.minimum_protocol_version
  }

  http_version        = var.http_version
  default_root_object = var.default_root_object

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [1] : []
    content {
      bucket          = var.logging_config.bucket
      prefix          = var.logging_config.prefix
      include_cookies = var.logging_config.include_cookies
    }
  }

  is_ipv6_enabled = var.is_ipv6_enabled
  comment         = var.comment
  enabled         = var.enabled

  tags = var.tags
}

