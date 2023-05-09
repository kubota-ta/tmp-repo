variable "name" {
  description = "ACL Name"
}

variable "metric_name" {
  description = "CloudWatch metric name"
}

variable "scope" {
  description = "Resource type"
}

variable "rules" {
  description = "IP set rules"
}

variable "default_action" {
  description = "Default action"
}

variable "rule_priority" {
  description = "Rule priority"
}

variable "cloudwatch_metrics" {
  description = "Amazon CloudWatch metrics"
}

variable "sampled_requests_enabled" {
  description = "Request sampling options"
}
