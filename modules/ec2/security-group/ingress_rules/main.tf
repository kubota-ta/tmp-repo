locals {

  name = format("%s-%s", var.env.prefix, var.name)

  rules = [
    for v in var.allow_rules : merge(
      {
        description = ""
        from_port   = var.rules[lookup(v, "rule", "_")][0]
        to_port     = var.rules[lookup(v, "rule", "_")][1]
        protocol    = var.rules[lookup(v, "rule", "_")][2]
      },
      v
  )]

}

/**
 * VPC > Security Groups
 */
resource "aws_security_group" "this" {

  ## Basic details
  # Security group name
  name = local.name

  # Description
  description = local.name

  # VPC
  vpc_id = var.vpc_id

  ## Inbound rules
  # later

  ## Outbound rules
  egress {
    # Type: All traffic
    #   - Protocol: (All)
    #   - Port range: (All)
    protocol  = "-1"
    from_port = 0
    to_port   = 0

    # Destination: Custom 0.0.0.0/0
    cidr_blocks = ["0.0.0.0/0"]

    # Description
    # skip
  }

  ## Tags
  tags = merge(
    { Name = local.name },
    var.env.tags
  )
}

/**
 * Security Groups > [Created security group]
 * Edit inbound rules
 */
resource "aws_security_group_rule" "this" {
  for_each = [
    for rule in local.rules : {
      for v in var.cidr_blocks : "${v.cidr_block}_${rule.to_port}" => merge(rule, v)
    }
  ][0]

  ## Security Groups > [Created security group]
  # Edit inbound rules
  security_group_id = aws_security_group.this.id
  type              = "ingress"

  # Type:
  #   - Protocol:
  #   - Port range:
  protocol  = each.value.protocol
  from_port = each.value.from_port
  to_port   = each.value.to_port

  # Source: Custom [self secutity group]
  cidr_blocks = [each.value.cidr_block]

  # Description
  description = each.value.description

  lifecycle {
    ## terraform で設定修正時にエラーになる対処
    # Security Group /security Group-rule recreation error #12420
    # https://github.com/hashicorp/terraform-provider-aws/issues/12420#issuecomment-776367137
    create_before_destroy = true
  }
}

