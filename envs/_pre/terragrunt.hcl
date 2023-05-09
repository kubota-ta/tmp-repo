locals {
  config  = read_terragrunt_config("../terragrunt-config.hcl")
  project = local.config.inputs.project
}

generate "terragrunt-variables" {
  path = "terragrunt-variables.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
variable "name" {
  description = "プロジェクト識別子"
  default     = "${local.project.name}"
}

variable "region" {
  description = "メインリージョン"
  default     = "${local.project.region}"
}

variable "aws_profile" {
  description = "AWSプロファイル"
  default     = "${local.project.aws_profile}"
}
EOF
}
