/**
 * Route 53 > Hosted zones
 * Create hosted zone
 *
 * 同時に以下のレコードが生成されます
 *   SOA レコード
 *   NS レコード
 */
resource "aws_route53_zone" "this" {

  ## Hosted zone configuration

  # Domain name
  name = var.domain

  # Description
  # skip
  comment = var.comment

  # Type: Public hosted zone

  # Tags
  tags = var.env.tags
}

