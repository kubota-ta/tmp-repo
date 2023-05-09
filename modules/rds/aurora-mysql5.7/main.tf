locals {
  family = "aurora-mysql5.7"
}

/**
 * RDS > Parameter groups > [Create parameter group]
 * 1つ目
 */
resource "aws_rds_cluster_parameter_group" "this" {

  ## Parameter group details

  # Parameter group family
  family = local.family

  # Group Name: DB Cluster Parameter Group

  # Group Name
  name = "${var.env.prefix}-${var.name}-cluster"

  # Group Description
  description = "${var.env.prefix}-${var.name}-cluster"

  dynamic "parameter" {
    for_each = var.db_cluster_params
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = contains(var.static-db-cluster-params, parameter.key) ? "pending-reboot" : "immediate"
    }
  }

  tags = var.env.tags
}

/**
 * RDS > Parameter groups > [Create parameter group]
 * 2つ目
 */
resource "aws_db_parameter_group" "this" {

  ## Parameter group details

  # Parameter group family
  family = local.family

  # Group Name: DB Cluster Parameter Group

  # Group Name
  name = "${var.env.prefix}-${var.name}"

  # Group Description
  description = "${var.env.prefix}-${var.name}"

  dynamic "parameter" {
    for_each = var.db_params
    content {
      name         = parameter.key
      value        = parameter.value
      apply_method = contains(var.static-db-params, parameter.key) ? "pending-reboot" : "immediate"
    }
  }

  tags = var.env.tags
}

/**
 * RDS > Databases > [Create database]
 */
module "rds" {
  source = "../../components/rds/aurora-mysql5.7"



  ## Choose a database creation method: Standard create

  db_cluster = {

    ## Engine options

    # Engine type: Amazon Aurora
    # Edition: Amazon Aurora with MySQL compatibility
    engine = "aurora-mysql"

    # Capacity type: Provisioned
    # Replication features: Single-master
    # Engine version: Aurora(MySQL 5.7) x.x.x
    engine_version = var.engine_version

    ## Templates: Production

    ## Settings

    # DB cluster identifier
    cluster_identifier = "${var.env.prefix}-${var.name}"

    # Credentials Settings

    # Master username
    master_username = var.master_username

    # Master password
    master_password = var.master_password
  }

  ## DB instance class
  db_instances = var.db_instances

  db_configuration = {

    ## Availability & durability
    # Multi-AZ deployment: (any)

    ## Connectivity
    # Virtual private cloud (VPC)
    # Subnet group
    db_subnet_group_name = var.db_subnet_group_name

    # Public access
    publicly_accessible = false

    # VPC security group
    vpc_security_group_ids = var.vpc_security_group_ids

    # Additional configuration
    # Database port: 3306

    ## Database authentication
    # Database authentication options: Password authentication
    iam_database_authentication_enabled = false

    ## Additional configuration

    # Initial database name: na
    #database_name = null

    # DB cluster parameter group
    db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.this.id

    # DB parameter group
    parameter_group_name = aws_db_parameter_group.this.id

    # Option group: na
    #option_group_name = null

    # Failover priority: na
    #promotion_tier = null

    # Backup retention period
    backup_retention_period = var.backup_retention_period
    # 時間設定は作成後に Modify で設定します
    preferred_backup_window = var.preferred_backup_window

    # Copy tags to snapshots: Yes
    copy_tags_to_snapshot = true

    # Enable encryption: No
    #kms_key_id = null

    # Enable Backtrack: No
    backtrack_window = 0

    # Enable Performance Insights: No
    performance_insights_enabled = false

    # Enable Enhanced monitoring: No
    monitoring_interval = var.monitoring_interval

    # Log exports
    # Audit log: No
    # Error log: No
    # General log: No
    # Slow query log: Yes
    enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

    # Enable auto minor version upgrade: No
    auto_minor_version_upgrade = false

    # Maintenance window: Select window
    # Start day:
    # Start time:
    # Duration
    preferred_maintenance_window = var.preferred_maintenance_window

    # Enable deletion protection: No
    deletion_protection = false

    # apply_immediately
    apply_immediately = var.apply_immediately
  }

  tags = var.env.tags
}

