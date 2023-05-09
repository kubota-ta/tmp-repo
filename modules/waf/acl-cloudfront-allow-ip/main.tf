terraform {
  required_providers { aws = {} }
}

/**
 * AWS WAF > IP sets
 */
resource "aws_wafv2_ip_set" "this" {

  # IP set name
  name = format("%s-%s", var.env.prefix, var.name)

  # Region
  scope = "CLOUDFRONT"

  # IP version
  ip_address_version = "IPV4"

  # IP addresses
  addresses = [
    for v in var.addresses : v.cidr_block
  ]
}

/**
 * Web ACLs
 */
module "acl" {
  source = "../../components/waf/acl-allow-ip"

  # Name
  name = format("%s-%s", var.env.prefix, var.name)

  # Description
  # skip

  # CloudWatch metric name
  metric_name = format("%s-%s", var.env.prefix, var.name)

  # Resource type
  scope = "CLOUDFRONT"

  # Associated AWS resources
  # later (-> CloudFront > Distributions)

  # Rules
  # Add rules > Add my own rules and rule groups
  # Rule type: IP set

  # Rule
  rules = {

    # Name
    allow-ip = {

      # IP set
      ip_set = aws_wafv2_ip_set.this.arn

      # IP address to use as the originating address: Source IP address

      # Action
      action = "allow"
    }
  }

  # Default action
  default_action = "block"

  # Set rule priority
  rule_priority = [
    "allow-ip"
  ]

  # Amazon CloudWatch metrics
  cloudwatch_metrics = {
    allow-ip = {
      enabled     = false
      metric_name = "allow-ip"
    }
  }

  # Request sampling options
  sampled_requests_enabled = false
}
