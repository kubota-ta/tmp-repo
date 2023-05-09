output "vpc" {
  description = "VPC/Subnets"
  value       = module.vpc
}

output "security_group" {
  description = "Security groups"
  value = {
    local = module.sg-local.security_group_id
    elb   = module.sg-elb.security_group_id
  }
}

output "s3_bucket" {
  description = "S3 buckets"
  value = {
    infra-log = module.s3-infra-log.bucket.id
  }
}

