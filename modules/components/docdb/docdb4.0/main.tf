resource "aws_docdb_cluster" "this" {
  engine = var.db_cluster.engine
  #engine_version = var.db_cluster.engine_version

  cluster_identifier              = var.db_cluster.cluster_identifier
  db_cluster_parameter_group_name = var.db_configuration.db_cluster_parameter_group_name

  master_username = var.db_cluster.master_username
  master_password = var.db_cluster.master_password

  backup_retention_period      = var.db_configuration.backup_retention_period
  preferred_backup_window      = var.db_configuration.preferred_backup_window
  preferred_maintenance_window = var.db_configuration.preferred_maintenance_window

  db_subnet_group_name   = var.db_configuration.db_subnet_group_name
  vpc_security_group_ids = var.db_configuration.vpc_security_group_ids
  storage_encrypted      = false
  #enabled_cloudwatch_logs_exports = var.db_configuration.enabled_cloudwatch_logs_exports
  deletion_protection = var.db_configuration.deletion_protection
  skip_final_snapshot             = true
  tags = var.tags

  lifecycle {
    ignore_changes = [master_password]
  }
}

resource "aws_docdb_cluster_instance" "this" {
  for_each = var.db_instances

  identifier         = "${aws_docdb_cluster.this.id}-${each.key}"
  cluster_identifier = aws_docdb_cluster.this.id

  #engine         = var.db_cluster.engine
  #engine_version = var.db_cluster.engine_version

  instance_class = each.value.instance_class

  preferred_maintenance_window = var.db_configuration.preferred_maintenance_window
  auto_minor_version_upgrade   = var.db_configuration.auto_minor_version_upgrade

  #db_subnet_group_name = var.db_configuration.db_subnet_group_name
  availability_zone = lookup(each.value, "availability_zone", null)
  promotion_tier    = lookup(each.value, "promotion_tier", 1)
  apply_immediately    = var.db_configuration.apply_immediately
  tags = var.tags
}
