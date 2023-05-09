locals {
  family = "docdb4.0"
}

/**
 * DocumentDB > Parameter groups > [Create parameter group]
 */
resource "aws_docdb_cluster_parameter_group" "this" {

  ## Parameter group details

  # Parameter group family
  family = local.family

  # Group Name: DocumentDB Cluster Parameter Group

  # Group Name
  name = "${var.env.prefix}-${var.name}"

  # Group Description
  description = "${var.env.prefix}-${var.name}"

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
 * DocumentDB > Databases > [Create database]
 */
module "docdb" {
  source = "../../components/docdb/docdb4.0"



  ## Choose a database creation method: Standard create

  db_cluster = {

    ## Engine options

    # Engine type: Amazon DocumentDB
    engine = "docdb"

    # Engine version: docdb x.x.x
    engine_version = var.engine_version

    ## Templates: Production

    ## Settings

    # DB cluster identifier
    cluster_identifier = "${var.env.prefix}-${var.name}"

    # Master username
    master_username = var.master_username

    # Master password
    master_password = var.master_password
  }

  ## DB instance class
  db_instances = var.db_instances

  db_configuration = {

    ## Connectivity

    # DB cluster parameter group
    db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.id

    # Backup retention period
    backup_retention_period = var.backup_retention_period

    # Preferred backup window
    preferred_backup_window = var.preferred_backup_window

    # Preferred maintenance window
    preferred_maintenance_window = var.preferred_maintenance_window

    # Subnet group name
    db_subnet_group_name = var.db_subnet_group_name

    # VPC security group
    vpc_security_group_ids = var.vpc_security_group_ids

    # Enable deletion protection: No
    deletion_protection = false

    # Database port
    # post = 27017

    ## Additional configuration

    # Storage encrypted
    storage_encrypted = false

    # Log exports
    # Audit log: No
    # Profiler log: No
    #enabled_cloudwatch_logs_exports = false

    # Enable auto minor version upgrade: No
    auto_minor_version_upgrade = false

    # Maintenance window: Select window
    # Start day:
    # Start time:
    # Duration
    preferred_maintenance_window = var.preferred_maintenance_window
    # apply_immediately
    apply_immediately = var.apply_immediately
  }

  tags = var.env.tags
}

