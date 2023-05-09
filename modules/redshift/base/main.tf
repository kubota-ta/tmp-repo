locals {

  ssm_prefix = "/${var.env.project.name}/${var.env.name}/redshift"

  ssm_params = {
    "master_user"     = "${var.env.project.name}_all"
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
 * Amazon Redshift > Configurations > Subnet groups
 */
resource "aws_redshift_subnet_group" "this" {

  # Name
  name = "${var.env.prefix}-front"

  # Description
  description = "front"

  # VPC
  ## Add subnets
  # Availability Zones
  # Subnet ID
  subnet_ids = var.subnet_ids

}
