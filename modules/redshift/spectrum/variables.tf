variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "family" {
  default = "redshift-1.0"
}

variable "node_type" {
  default = "dc2.large"
}

variable "number_of_nodes" {
  default = 1
}

variable "master_username" {
}

variable "master_password" {
}

variable "security_group_ids" {
}

variable "cluster_subnet_group_name" {
}

variable "preferred_maintenance_window" {
}

variable "automated_snapshot_retention_period" {
  default = 7
}

