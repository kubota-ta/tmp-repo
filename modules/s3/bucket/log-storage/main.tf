/**
 * S3 > Buckets
 */
module "s3_bucket" {
  source = "../../../components/s3/bucket/log-storage"

  # Bucket name
  name = format("%s-%s", var.env.prefix, var.name)

  # AWS Region: ap-northeast-1

  # Block Public Access settings for this bucket: Block all public access

  # Bucket Versioning: Disable

  # Tags
  tags = var.env.tags

  # Default encryption: Disable

  # Object Lock: Disable

  ## Buckets > [Created bucket]
  # Management > Lifecycle rules

  ## ログを格納するシステムの数分作る
  # Lifecycle rule name: elb
  # Choose a rule scope: Limit the scope of this rule using one or more filters
  # Prefix: elb/
  # Lifecycle rule actions: Expire current versions of objects
  # Number of days after object creation: 14
  lifecycle_rule = var.lifecycle_rule
}

