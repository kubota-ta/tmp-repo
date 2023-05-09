terraform {
  required_providers { aws = {} }
}

/**
 * AWS Certificate Manager > Certificates
 * Request a public certificate
 */
resource "aws_acm_certificate" "this" {

  # Add domain names
  domain_name = var.domain

  # Select validation method: DNS validation
  validation_method = "DNS"

  # Add tags
  tags = var.env.tags

  lifecycle {
    create_before_destroy = true
  }
}

# Validation: Create record in Route 53
resource "aws_route53_record" "this" {
  for_each = {
    for dvo in aws_acm_certificate.this.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  # Hosted zone
  zone_id = var.zone_id

  # Record name
  name = each.value.name

  # Record type
  type = each.value.type

  # Value
  records = [each.value.record]

  # Alias: No

  # TTL (seconds)
  ttl = 300

  # Routing policy: Simple routing

  # エラー回避：
  # "Tried to create resource record set ... but it already exists"
  # ワイルドカードを使った証明書を作成しようとすると
  # ワイルドカードとルートドメインの検証用レコードが同じ内容になるため
  allow_overwrite = true
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn         = aws_acm_certificate.this.arn
  validation_record_fqdns = [for v in aws_route53_record.this : v.fqdn]
}

