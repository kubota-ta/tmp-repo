locals {
  name = format("%s-%s", var.env.prefix, var.name)
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


  ## Security Groups > [Created security group]
  # Edit inbound rules
  ingress {

    # Type: All traffic
    #   - Protocol: (All)
    #   - Port range: (All)
    protocol  = "-1"
    from_port = 0
    to_port   = 0

    # Source: Custom [self secutity group]
    self = true

    # Description
    # skip
  }
}
