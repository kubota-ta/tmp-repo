# VPC/Subnets/Gateway と基本の NetworkACL
module "vpc" {
  source     = "../../../modules/vpc/vpc/multi-subnets"
  env        = module.env
  cidr_block = "172.20.0.0/16"
}

# Security group: ローカルアクセス用
module "sg-local" {
  source = "../../../modules/ec2/security-group/self"
  env    = module.env
  vpc_id = module.vpc.vpc_id
  name   = "local"
}

# Security group: ELBアクセス
module "sg-elb" {
  source = "../../../modules/ec2/security-group/self"
  env    = module.env
  vpc_id = module.vpc.vpc_id
  name   = "elb"
}

# S3 bucket: システムログ格納用のバケット
module "s3-infra-log" {
  source = "../../../modules/s3/bucket/log-storage"
  env    = module.env
  name   = "infra-log"
  lifecycle_rule = {
    elb        = 30,
    cloudfront = 30,
  }
}

