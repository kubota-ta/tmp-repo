variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "description" {
  description = "Description"
}

variable "iam_role" {
  description = "IAM Role ARN"
}

variable "target_tags" {
  description = "Target tags"
}

variable "starting_at" {
  description = "Execution time (UTC)"
}

variable "reboot" {
  description = "Whether should be rebooted before AMI creation"
  default     = false
}

variable "retention_count" {
  description = "Count keep AMIs"
}


