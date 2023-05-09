locals {
  family = "redis4.0"
}

/**
 * ElastiCache > Parameter Groups > Create Parameter Group
 */
resource "aws_elasticache_parameter_group" "this" {

  # Family
  family = local.family

  # Name
  name = "${var.env.prefix}-${var.name}"

  # Description
  description = "${var.env.prefix}-${var.name}"

  # Tags
  tags = var.env.tags

  dynamic "parameter" {
    for_each = var.cache_params
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
}

/**
 * ElastiCache > Redis > Create
 */
resource "aws_elasticache_replication_group" "this" {

  ## Create your Amazon ElastiCache cluster

  # Cluster engine: Redis
  # Cluster Mode enabled: No
  engine = "redis"

  ## Location

  # Choose a location: Amazon Cloud

  ## Redis settings

  # Name
  replication_group_id = "${var.env.prefix}-${var.name}"

  # Description
  replication_group_description = "${var.env.prefix}-${var.name}"

  # Engine version compatibility
  engine_version = var.engine_version

  # Port
  port = 6379

  # Parameter group
  parameter_group_name = aws_elasticache_parameter_group.this.id

  # Node type
  node_type = var.node_type

  # Number of replicas
  number_cache_clusters = var.number_cache_clusters

  # Multi-AZ, Auto failover
  multi_az_enabled           = var.number_cache_clusters > 1 ? true : false
  automatic_failover_enabled = var.number_cache_clusters > 1 ? true : false

  ## Advanced Redis settings

  # Subnet group
  subnet_group_name = var.subnet_group_name

  # Availability zones placement
  availability_zones = var.availability_zones

  ## Security

  # Security groups
  security_group_ids = var.security_group_ids

  # Encryption at-rest
  at_rest_encryption_enabled = false

  # Encryption in-transit
  transit_encryption_enabled = false

  ## Import data to cluster
  # Seed RDB file S3 location: na

  ## Backup

  # Enable automatic backups: Yes
  # Backup retention period
  snapshot_retention_limit = var.backup_retention_period

  # Backup window
  snapshot_window = var.backup_window

  ## Maintenance

  # Maintenance window: Specify maintenance window
  maintenance_window = var.maintenance_window

  # Topic for SNS notification
  notification_topic_arn = var.notification_topic_arn

  ## Tags
  tags = var.env.tags

  ## apply immediately
  apply_immediately = var.apply_immediately

  lifecycle {
    ignore_changes = [availability_zones]
  }
}
