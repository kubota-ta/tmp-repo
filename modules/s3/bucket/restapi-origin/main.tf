terraform {
  required_providers { aws = {} }
}

locals {
  name = format("%s-%s", var.env.prefix, var.name)
}

/**
 * CloudFront > Origin access identities
 */
resource "aws_cloudfront_origin_access_identity" "this" {
  comment = local.name
}

/**
 * S3 > Buckets
 */
module "s3_bucket" {
  source = "../../../components/s3/bucket/restapi-origin"

  # Bucket name
  name = local.name

  # AWS Region: ap-northeast-1

  # Block Public Access settings for this bucket: Block all public access

  # Bucket Versioning: Disable

  # Tags
  tags = var.env.tags

  # Default encryption: Disable

  # Object Lock: Disable

  ## Buckets > [Created bucket] > Permissions > Cross-origin resource sharing (CORS)
  cors_rule = {
    allowed_headers = var.allowed_headers
    allowed_methods = var.methods
    allowed_origins = var.origins
    expose_headers  = []
    max_age_seconds = var.max_age_seconds
  }
}

/**
 * Buckets > [Created bucket] > Permissions > Bucket policy
 */
# ドキュメントポリシーの準備
data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.this.iam_arn]
    }
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.bucket.arn}/*"]
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = module.s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.this.json
}

