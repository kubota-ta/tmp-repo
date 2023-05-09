/**
 * CloudFront > Distributions
 */
resource "aws_cloudfront_distribution" "this" {

  dynamic "origin" {
    for_each = var.origins
    content {

      domain_name = origin.value.domain_name
      origin_path = origin.value.origin_path

      dynamic "origin_shield" {
        for_each = (origin.value.origin_shield.enabled == true
        ? { origin_shield = origin.value.origin_shield } : {})
        content {
          enabled              = origin_shield.value.enabled
          origin_shield_region = origin_shield.value.origin_shield_region
        }
      }

      origin_id           = origin.value.origin_id
      connection_attempts = origin.value.connection_attempts
      connection_timeout  = origin.value.connection_timeout

      dynamic "custom_header" {
        for_each = lookup(origin.value, "custom_header", [])
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }

      dynamic "custom_origin_config" {
        for_each = lookup(origin.value, "origin_ssl_protocols", false) != false ? [1] : []
        content {
          origin_ssl_protocols   = origin.value.origin_ssl_protocols
          origin_protocol_policy = origin.value.origin_protocol_policy

          origin_read_timeout      = origin.value.origin_read_timeout
          origin_keepalive_timeout = origin.value.origin_keepalive_timeout

          http_port  = origin.value.http_port
          https_port = origin.value.https_port
        }
      }

      dynamic "s3_origin_config" {
        for_each = lookup(origin.value, "origin_access_identity", false) != false ? [1] : []
        content {
          origin_access_identity = origin.value.origin_access_identity
        }
      }
    }
  }

  default_cache_behavior {
    target_origin_id = var.behaviors.default.target_origin_id

    viewer_protocol_policy = var.behaviors.default.viewer_protocol_policy
    allowed_methods        = var.behaviors.default.allowed_methods
    cached_methods         = var.behaviors.default.cached_methods

    field_level_encryption_id = var.behaviors.default.field_level_encryption_id

    forwarded_values {
      headers = var.behaviors.default.headers
      cookies {
        forward           = var.behaviors.default.cookies.forward
        whitelisted_names = var.behaviors.default.cookies.whitelisted_names
      }
      query_string            = var.behaviors.default.query_string
      query_string_cache_keys = var.behaviors.default.query_string_cache_keys
    }

    smooth_streaming = var.behaviors.default.smooth_streaming
    compress         = var.behaviors.default.compress

    #function_association {}
    #未対応

    realtime_log_config_arn = var.behaviors.default.realtime_log_config_arn

    min_ttl     = var.behaviors.default.min_ttl
    max_ttl     = var.behaviors.default.max_ttl
    default_ttl = var.behaviors.default.default_ttl
  }

  dynamic "ordered_cache_behavior" {
    for_each = {
      for k, v in var.behaviors : k => v if k != "default"
    }
    content {
      target_origin_id = ordered_cache_behavior.value.target_origin_id
      path_pattern     = ordered_cache_behavior.value.path_pattern

      viewer_protocol_policy = ordered_cache_behavior.value.viewer_protocol_policy
      allowed_methods        = ordered_cache_behavior.value.allowed_methods
      cached_methods         = ordered_cache_behavior.value.cached_methods

      field_level_encryption_id = ordered_cache_behavior.value.field_level_encryption_id

      forwarded_values {
        headers = ordered_cache_behavior.value.headers
        cookies {
          forward           = ordered_cache_behavior.value.cookies.forward
          whitelisted_names = ordered_cache_behavior.value.cookies.whitelisted_names
        }
        query_string            = ordered_cache_behavior.value.query_string
        query_string_cache_keys = ordered_cache_behavior.value.query_string_cache_keys
      }

      smooth_streaming = ordered_cache_behavior.value.smooth_streaming
      compress         = ordered_cache_behavior.value.compress

      #function_association {}
      #未対応

      realtime_log_config_arn = ordered_cache_behavior.value.realtime_log_config_arn

      min_ttl     = ordered_cache_behavior.value.min_ttl
      max_ttl     = ordered_cache_behavior.value.max_ttl
      default_ttl = ordered_cache_behavior.value.default_ttl
    }
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
    cloudfront_default_certificate = var.acm_certificate_arn == null

    acm_certificate_arn      = var.acm_certificate_arn
    ssl_support_method       = var.ssl_support_method
    minimum_protocol_version = var.minimum_protocol_version
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

