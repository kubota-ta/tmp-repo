data "aws_canonical_user_id" "current_user" {}
resource "aws_s3_bucket" "this" {
  bucket = var.name
  tags   = var.tags
}

resource "aws_s3_bucket_lifecycle_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  dynamic "rule" {
    for_each = var.lifecycle_rule
    content {
      id = rule.key
      filter {
        prefix = "${rule.key}/"
      }
      status = "Enabled"
      expiration {
        days = rule.value
      }
    }
  }
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id

  access_control_policy {
    owner {
      id = data.aws_canonical_user_id.current_user.id
    }

    # own access
    grant {
      grantee {
        id   = data.aws_canonical_user_id.current_user.id
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }

    # CloudFront ログ出力 - AWS Logs Delivery
    grant {
      grantee {
        id   = "c4c1ede66af53448b93c283ce9448c4ba468c9432aa01d700d3878632f77d2d0"
        type = "CanonicalUser"
      }
      permission = "FULL_CONTROL"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

data "aws_caller_identity" "current" {}
data "template_file" "this" {
  for_each = toset([
    "bucket_policy"
  ])
  template = file("${path.module}/files/${each.key}.yml")
  vars = {
    aws_id         = data.aws_caller_identity.current.account_id,
    elb_account_id = "582318560864", # ap-northeast-1
    bucket_id      = aws_s3_bucket.this.id,
  }
}

# ELB ログ出力
resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode(yamldecode(data.template_file.this["bucket_policy"].rendered)["Policy"])
}

