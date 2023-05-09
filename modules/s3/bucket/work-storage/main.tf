/**
 * S3 > Buckets
 */
module "s3_bucket" {
  source = "../../../components/s3/bucket/work-storage"

  # Bucket name
  name = format("%s-%s", var.env.prefix, var.name)

  # AWS Region: ap-northeast-1

  # Block Public Access settings for this bucket: Block all public access

  # Bucket Versioning: Disable

  # Tags
  tags = var.env.tags

  # Default encryption: Disable

  # Object Lock: Disable
}

