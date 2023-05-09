variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "subnet_group_name" {
  description = "サブネットグループ名"
}

variable "cache_params" {
  description = "Cache Parameter"
  default = {
    # https://docs.aws.amazon.com/AmazonElastiCache/latest/red-ug/redis-memory-management.html
    # >The rule of thumb is to reserve half of a node type's maxmemory value for Redis overhead for versions before 2.8.22, and one-fourth for Redis versions 2.8.22 and later.
    # 2.8.22 以降でもバックアップ時に負荷異常が確認されているため、50%推奨
    reserved-memory-percent = 50
  }
}

variable "engine_version" {
  description = "Engine version"
  default     = "6.2"
}

variable "node_type" {
  description = "Node type"
  default     = "cache.t3.micro"
}

variable "number_cache_clusters" {
  description = "Number cache clusters"
  default     = 1
}

variable "availability_zones" {
  description = "Availability zones"
}

variable "security_group_ids" {
  description = "Security group IDs"
}
#variable "security_group_names" {}

variable "backup_retention_period" {
  description = "Backup retention period(days)"
}

variable "backup_window" {
  description = "Backup window(UTC)"
  default     = "19:00-20:00"
}

variable "maintenance_window" {
  description = "Maintenance window(UTC)"
  default     = "wed01:00-wed02:00"
}

variable "notification_topic_arn" {
  description = "Topic ARN for SNS notification"
}

variable "apply_immediately" {
  description = "apply immediately"
  default     = "false"
}