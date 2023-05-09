variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "db_subnet_group_name" {
  description = "サブネットグループ名"
}

variable "db_instances" {
  description = "インスタンスの枝番、クラス、優先度"
  default = {
    #"001" = { instance_class = "db.t3.small", promotion_tier = 1, availability_zone = "ap-northeast-1a" }
    #"002" = { instance_class = "db.t3.small", promotion_tier = 2, availability_zone = "ap-northeast-1d" }
  }
}

variable "master_username" {
  description = "マスターユーザ名"
}

variable "master_password" {
  description = "マスターユーザパスワード"
}

variable "db_cluster_params" {
  description = "DB Cluster Parameter"
  default = {
  }
}

variable "engine_version" {
  description = "Engine version"
  default     = "4.0"
}

variable "vpc_security_group_ids" {
  description = "Security Group IDs"
}

variable "backup_retention_period" {
  description = "Backup retention period(1-35days)"
  default     = 1
}

variable "preferred_backup_window" {
  description = "Backup window(UTC)"
  default     = "19:00-20:00"
}

variable "preferred_maintenance_window" {
  description = "Maintenance window(UTC)"
  default     = "wed:05:00-wed:05:30"
}

variable "monitoring_interval" {
  description = "Enhanced Monitoring interval"
  default     = 0
}

variable "enabled_cloudwatch_logs_exports" {
  description = "Log exports to CloudWatch"
  default = [
    # "audit",
    # "profiler",
  ]
}
variable "apply_immediately" {
  description = "apply immediately"
  default     = false
}