locals {
  config       = read_terragrunt_config("../../terragrunt-config.hcl")
  project      = local.config.inputs.project
  requirements = local.config.inputs.requirements
}

/**
 * generate files
 */
remote_state {
  backend = "s3"
  generate = {
    path      = "terragrunt-backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    region  = local.project.region
    bucket  = "${local.project.name}-tfstate"
    key     = "${path_relative_to_include()}.tfstate"
    profile = "${local.project.aws_profile}"
  }
}

generate "project" {
  path = "${path_relative_from_include()}/terragrunt-project.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
output "name" {
  description = "プロジェクト識別子"
  value       = "${local.project.name}"
}

output "region" {
  description = "メインリージョン"
  value       = "${local.project.region}"
}

output "key-pair" {
  description = "EC2の構築に共通で利用するキーペア"
  value       = "${local.project.key-pair}"
}

output "tags" {
  description = "作成したリソースに共通して付与するタグ"
  value = {
    Terraform = true
  }
}

output "domain" {
  description = "管理ドメイン"
  value       = ${jsonencode(local.project.domain)}
}

output "aws_profile" {
  description = "AWSプロファイル"
  value       = "${local.project.aws_profile}"
}
EOF
}

generate "provider" {
  path = "terragrunt-provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "aws" {
  region  = module.env.project.region
  profile = module.env.project.aws_profile
}

##グローバルリソース(主にCloudFront関連)向け
provider "aws" {
  # 参考
  # https://github.com/terraform-aws-modules/terraform-aws-cloudfront/blob/v2.6.0/examples/complete/main.tf
  alias = "global"

  # CloudFront expects ACM resources in us-east-1 region only
  region = "us-east-1"

  # Make it faster by skipping something
  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = false # profile利用に必要でした
  skip_region_validation      = true
  skip_credentials_validation = true

  profile = module.env.project.aws_profile
}

##nutaku版向け(オレゴンリージョン)
provider "aws" {
  alias  = "oregon"
  region = "us-west-2"

  skip_get_ec2_platforms      = true
  skip_metadata_api_check     = false
  skip_region_validation      = true
  skip_credentials_validation = true

  profile = module.env.project.aws_profile
}
EOF
}

generate "requirements" {
  path = "terragrunt-requirements.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
terraform {
  required_version = "${local.requirements.terraform}"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "${local.requirements.aws}"
    }
  }
}
EOF
}

generate "load" {
  path = "terragrunt-load.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
module "env" {
  source = "../"
}
EOF
}
