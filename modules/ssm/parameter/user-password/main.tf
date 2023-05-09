locals {

  ssm_prefix = "/${var.env.project.name}/${var.env.name}/${var.key_prefix}"
  ssm_params = {
    "master_user"     = var.user == null ? var.key_prefix : var.user
    "master_password" = random_password.this.result
  }

}

# password 生成
resource "random_password" "this" {
  length  = var.pass_length
  special = var.pass_special
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
