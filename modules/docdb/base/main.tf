locals {

  ssm_prefix = "/${var.env.project.name}/${var.env.name}/docdb"

  ssm_params = {
    # Only alphanumeric characters can be used in the user name.
    "master_user"     = "${var.env.project.name}all"
    "master_password" = random_password.db_password.result
  }

}

# password 生成
resource "random_password" "db_password" {
  length  = 16
  special = false
}

/**
 * AWS Systems Manager > Parameter Store > [Create parameter]
 */
resource "aws_ssm_parameter" "this" {
  for_each = local.ssm_params

  ## Parameter details

  # Name
  name = "${local.ssm_prefix}/${each.key}"

  # Description

  # Tier: Standard

  # Type
  type = "SecureString"
  # KMS key source: My current account
  # KMS Key ID: alias/aws/ssm

  # Value
  value = each.value

  ## Tags
  tags = var.env.tags
}

/**
 * DocumentDB > Subnet groups > [Create DocumentDB Subnet Group]
 */
resource "aws_docdb_subnet_group" "this" {

  ## Subnet group details

  # Name
  name = "${var.env.prefix}-private"

  # Description
  description = "private"

  # VPC
  ## Add subnets
  # Availability Zones
  # Subnets
  subnet_ids = var.subnet_ids

}

