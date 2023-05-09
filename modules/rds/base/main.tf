# password 生成
module "db_user" {
  source     = "../../ssm/parameter/user-password"
  env        = var.env
  key_prefix = "db"
  user       = "${var.env.project.name}_all"
}

/**
 * RDS > Subnet groups > [Create DB Subnet Group]
 */
resource "aws_db_subnet_group" "this" {

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

