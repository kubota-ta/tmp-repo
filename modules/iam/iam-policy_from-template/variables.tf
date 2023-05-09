variable "env" {
  description = "環境変数"
}

variable "template" {
  description = "IAMRole - Policy 構成テンプレート"
  default = {
    #"use case name" = {
    #  aws_managed_policies                = [ "policy arn", ... ]
    #  available_customer_managed_policies = [ "policy name", ... ]
    #  customer_managed_policies           = {
    #    "policy name" = { "policy document template" }, ...
    #  }
    #}, ...
  }
}

variable "template_vars" {
  description = "テンプレート変数"
  default = {
    #key = value
  }
}
