terraform {
  required_providers { aws = {} }
}

data "aws_region" "current" {}

locals {
  subnets = var.subnets[data.aws_region.current.name]
}

/**
 * VPC > Your VPCs
 */
resource "aws_vpc" "this" {

  # Name tag
  # -> tags.Name

  # IPv4 CIDR block
  cidr_block = var.cidr_block

  # IPv6 CIDR block: No IPv6 CIDR block
  assign_generated_ipv6_cidr_block = false

  # Tenancy
  instance_tenancy = "default"

  # Tags
  tags = merge(
    { Name = format("%s-vpc", var.env.prefix) },
    var.env.tags
  )

  ## Your VPCs > [Created VPC]
  # Edit DNS resolution
  enable_dns_support = true

  # Edit DNS hostnames
  enable_dns_hostnames = true
}

/**
 * VPC > Subnets
 */
resource "aws_subnet" "public" {
  for_each = merge([
    for snet, snet_no in var.public_subnets : {
      for zone, zone_no in local.subnets.zones :
      "${snet}-${zone}" => cidrsubnet(var.cidr_block, 8, (zone_no * 10) + snet_no)
    }
  ]...)

  ## VPC
  # VPC ID
  vpc_id = aws_vpc.this.id

  ## Subnet settings
  # Subnet name
  # -> tags.Name

  # Availability Zone
  availability_zone = "${local.subnets.region}${(split("-", each.key))[1]}"

  # IPv4 CIDR block
  cidr_block = each.value

  ## (Tags)
  tags = merge(
    { Name = format("%s-subnet-%s", var.env.prefix, each.key) },
    var.env.tags
  )
}

resource "aws_subnet" "private" {
  for_each = merge([
    for snet, snet_no in var.private_subnets : {
      for zone, zone_no in local.subnets.zones :
      "${snet}-${zone}" => cidrsubnet(var.cidr_block, 8, (zone_no * 10) + snet_no)
    }
  ]...)

  ## VPC
  # VPC ID
  vpc_id = aws_vpc.this.id

  ## Subnet settings
  # Subnet name
  # -> tags.Name

  # Availability Zone
  availability_zone = "${local.subnets.region}${(split("-", each.key))[1]}"

  # IPv4 CIDR block
  cidr_block = each.value

  ## (Tags)
  tags = merge(
    { Name = format("%s-subnet-%s", var.env.prefix, each.key) },
    var.env.tags
  )
}

/**
 * VPC > Internet gateways
 */
resource "aws_internet_gateway" "this" {
  for_each = {
    for k, v in local.subnets.gw :
    v.igw => k... if false != lookup(v, "igw", false)
  }

  ## Internet gateway settings
  # Name tag
  # -> tags.Name

  ## Tags
  tags = merge(
    { Name = format("%s-igw-%s", var.env.prefix, each.key) },
    var.env.tags
  )

  ## Internet gateways > [Created IGW]
  # Attach to VPC
  vpc_id = aws_vpc.this.id
}


/**
 * VPC > Elastic IP addresses
 * NatGateway用のIPアドレスを確保する
 */
resource "aws_eip" "ngw" {
  for_each = {
    for k, v in local.subnets.gw :
    v.ngw => k... if false != lookup(v, "ngw", false)
  }

  vpc      = true
  ## Elastic IP address settings
  # Network Border Group
  # アドレスを付け替えたくなった時のために、AZ縛りはしない
  network_border_group = local.subnets.region

  # Public IPv4 address pool
  public_ipv4_pool = "amazon"

  ## Tags
  tags = merge(
    { Name = format("%s-ngw-%s", var.env.prefix, each.key) },
    var.env.tags
  )
}

/**
 * VPC > NAT gateways
 */
resource "aws_nat_gateway" "this" {
  for_each = aws_eip.ngw

  ## NAT gateway settings
  # Name
  # -> tags:Name

  # Subnet
  subnet_id = aws_subnet.public[each.key].id

  # Connectivity type
  connectivity_type = "public"

  # Elastic IP allocation ID
  allocation_id = each.value.id

  ## Tags
  tags = merge(
    { Name = format("%s-ngw-%s", var.env.prefix, each.key) },
    var.env.tags
  )
}

/**
 * VPC > Route tables
 */
# Internet gateway を通るルート（パブリックサブネット用）
resource "aws_route_table" "igw" {
  for_each = aws_internet_gateway.this

  ## Route table settings
  # Name
  # -> tags.Name

  # VPC
  vpc_id = aws_vpc.this.id

  ## Tags
  tags = merge(
    { Name = format("%s-route-igw-%s", var.env.prefix, each.key) },
    var.env.tags
  )

  ## Route Tables > [Created Route table]
  # Edit routes
  route {

    # Destination
    cidr_block = "0.0.0.0/0"

    # Target
    gateway_id = each.value.id
  }
}

# Nat gateway を通るルート（プライベートサブネット用）
resource "aws_route_table" "ngw" {
  for_each = aws_nat_gateway.this

  ## Route table settings
  # Name
  # -> tags.Name

  # VPC
  vpc_id = aws_vpc.this.id

  ## Tags
  tags = merge(
    { Name = format("%s-route-ngw-%s", var.env.prefix, each.key) },
    var.env.tags
  )

  ## Route Tables > [Created Route table]
  # Edit routes
  route {
    # Destination
    cidr_block = "0.0.0.0/0"

    # Target
    nat_gateway_id = each.value.id
  }
}

/**
 * VPC > Route tables > [route table] > Edit subnet associations
 */
resource "aws_route_table_association" "igw" {
  for_each = {
    for k, v in aws_subnet.public :
    k => local.subnets.gw[k].igw if false != lookup(local.subnets.gw, k, false)
  }

  route_table_id = aws_route_table.igw[each.value].id

  # Available subnets
  subnet_id = aws_subnet.public[each.key].id
}

resource "aws_route_table_association" "ngw" {
  for_each = {
    for k, v in aws_subnet.private :
    k => local.subnets.gw[k].ngw if false != lookup(local.subnets.gw, k, false)
  }

  route_table_id = aws_route_table.ngw[each.value].id

  # Available subnets
  subnet_id = aws_subnet.private[each.key].id
}

/**
 * VPC > Network ACLs
 */
resource "aws_network_acl" "this" {
  ## Route table settings
  # Name
  # -> tags.Name

  # VPC
  vpc_id = aws_vpc.this.id

  # Tags
  tags = merge(
    { Name = format("%s-acl", var.env.prefix) },
    var.env.tags
  )

  ## Network ACLs > [Created ACL]

  # Edit inbound rules
  # トレンドマイクロ拒否
  ingress {
    protocol   = "-1"
    rule_no    = 1
    action     = "deny"
    cidr_block = "150.70.0.0/16"
    from_port  = 0
    to_port    = 0
  }

  # 全許可
  ingress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Edit outbound rules
  # 全許可
  egress {
    protocol   = "-1"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    to_port    = 0
  }

  # Edit subnet associations
  subnet_ids = concat(
    values(aws_subnet.public)[*].id,
    values(aws_subnet.private)[*].id
  )
}
