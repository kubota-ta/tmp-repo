resource "aws_rds_cluster" "this" {
  engine         = var.db_cluster.engine
  engine_version = var.db_cluster.engine_version

  cluster_identifier              = var.db_cluster.cluster_identifier
  db_cluster_parameter_group_name = var.db_configuration.db_cluster_parameter_group_name

  iam_database_authentication_enabled = var.db_configuration.iam_database_authentication_enabled
  master_username                     = var.db_cluster.master_username
  master_password                     = var.db_cluster.master_password

  backup_retention_period      = var.db_configuration.backup_retention_period
  copy_tags_to_snapshot        = var.db_configuration.copy_tags_to_snapshot
  preferred_backup_window      = var.db_configuration.preferred_backup_window
  preferred_maintenance_window = var.db_configuration.preferred_maintenance_window
  backtrack_window             = var.db_configuration.backtrack_window

  db_subnet_group_name            = var.db_configuration.db_subnet_group_name
  vpc_security_group_ids          = var.db_configuration.vpc_security_group_ids
  storage_encrypted               = false
  skip_final_snapshot             = true
  enabled_cloudwatch_logs_exports = var.db_configuration.enabled_cloudwatch_logs_exports
  deletion_protection             = var.db_configuration.deletion_protection

  tags = var.tags

  lifecycle {
    ignore_changes = [master_password]
  }
}

resource "aws_rds_cluster_instance" "this" {
  for_each = var.db_instances

  identifier              = "${aws_rds_cluster.this.id}-${each.key}"
  cluster_identifier      = aws_rds_cluster.this.id
  db_parameter_group_name = var.db_configuration.parameter_group_name

  engine         = var.db_cluster.engine
  engine_version = var.db_cluster.engine_version

  instance_class = each.value.instance_class

  performance_insights_enabled = var.db_configuration.performance_insights_enabled
  monitoring_interval          = var.db_configuration.monitoring_interval
  copy_tags_to_snapshot        = false

  # 下記のエラー回避のため Cluster 側で設定
  #  Error: error creating RDS Cluster (gbng-prd-db01) Instance: InvalidParameterCombination: The requested DB Instance will be a member of a DB Cluster. Set backup window for the DB Cluster.
  #preferred_backup_window      = var.db_configuration.preferred_backup_window

  preferred_maintenance_window = var.db_configuration.preferred_maintenance_window
  auto_minor_version_upgrade   = var.db_configuration.auto_minor_version_upgrade

  db_subnet_group_name = var.db_configuration.db_subnet_group_name
  availability_zone    = lookup(each.value, "availability_zone", null)
  promotion_tier       = lookup(each.value, "promotion_tier", 1)
  publicly_accessible  = var.db_configuration.publicly_accessible
  apply_immediately    = var.db_configuration.apply_immediately

  tags = var.tags
}
