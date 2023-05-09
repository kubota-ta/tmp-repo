locals {
  name = format("%s-%s", var.env.prefix, var.name)
}

## IAMポリシー作成
data "template_file" "this" {
  for_each = toset([
    "AWSRedshiftSpectrumRole",
  ])
  template = file("${path.module}/files/${each.key}.yml")
  vars     = {}
}

## IAMロール作成
resource "aws_iam_role" "this" {
  assume_role_policy = jsonencode(
    yamldecode(data.template_file.this["AWSRedshiftSpectrumRole"].rendered)["AssumeRole"]
  )
  managed_policy_arns = yamldecode(
    data.template_file.this["AWSRedshiftSpectrumRole"].rendered
  )["ManagedPolicies"]

  tags = var.env.tags
  name = local.name
  path = "/"
}

/**
 * Amazon Redshift > Configurations > Workload management > Create parameter group
 */
resource "aws_redshift_parameter_group" "this" {

  # Parameter group name
  name = local.name

  # Description
  #description =

  family = var.family
  tags   = var.env.tags
}

/**
 * Amazon Redshift > Clusters > Create cluster
 */
resource "aws_redshift_cluster" "this" {

  ## Cluster configuration

  # Cluster identifier
  cluster_identifier = local.name

  # What are you planning to use this cluster for?: Production

  # Node type
  node_type = var.node_type

  # Number of nodes
  cluster_type    = var.number_of_nodes > 1 ? "multi-node" : "single-node"
  number_of_nodes = var.number_of_nodes

  ## Sample data
  # Load sample data: No

  ## Database configurations

  # Admin user name
  master_username = var.master_username

  # Auto generate password: No
  # Admin user password
  master_password = var.master_password

  ## Cluster permissions

  # Available IAM roles
  iam_roles = [aws_iam_role.this.arn]

  ## Additional configurations

  ## Network and security

  # Virtual private cloud (VPC)

  # VPC security groups
  vpc_security_group_ids = var.security_group_ids

  # Cluster subnet group
  cluster_subnet_group_name = var.cluster_subnet_group_name

  # Availability Zone
  #availability_zone =

  # Enhanced VPC routing
  enhanced_vpc_routing = false

  # Publicly accessible: Enable
  publicly_accessible = true

  # Elastic IP address: None
  #elastic_ip =

  ## Database configurations

  # Database name
  database_name = var.env.name

  # Database port
  port = 5439

  # Parameter groups
  cluster_parameter_group_name = aws_redshift_parameter_group.this.id

  # Encryption
  encrypted = false

  ## Maintenance

  # Use default maintenance window: No
  # Maintenance window
  preferred_maintenance_window = var.preferred_maintenance_window

  # Maintenance track: Current

  ## Monitoring
  # CloudWatch alarm
  # No alarms: Yes

  ## Backup
  # Snapshot retention: 7 days
  automated_snapshot_retention_period = var.automated_snapshot_retention_period

  # Configure cross-region snapshot: Disabled
  # Cluster relocation: No
}
