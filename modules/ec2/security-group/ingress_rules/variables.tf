variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "cidr_blocks" {
  description = "CIDRのリスト"
}

variable "allow_rules" {
  description = "CIDRに適用するルールのリスト"
  default     = [{ rule = "all-all" }]
}
