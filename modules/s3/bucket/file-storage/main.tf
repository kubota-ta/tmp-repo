/**
 * S3 bucket
 */
resource "aws_s3_bucket" "this" {
  bucket = format("%s-%s", var.env.prefix, var.name)
  tags   = var.env.tags
}

resource "aws_s3_bucket_acl" "this" {
  bucket = aws_s3_bucket.this.id

  acl = "private"
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

/**
 * IAM User
 */
resource "aws_iam_user" "this" {
  name = "${aws_s3_bucket.this.id}-rw"
  tags = var.env.tags
}

# IAM User Inline Policy
resource "aws_iam_user_policy" "allow_ip_address" {
  name = "allow-ip-address"
  user = aws_iam_user.this.name
  policy = templatefile(
    "${path.module}/files/allow-ip-address.yml",
    {
      allow_ip_address = [for i in var.allow_cidr_blocks : i.cidr_block]
    }
  )
}

resource "aws_iam_user_policy" "bucket_access" {
  name = "bucket-access"
  user = aws_iam_user.this.name
  policy = templatefile(
    "${path.module}/files/bucket-access.yml",
    {
      bucket_arn = aws_s3_bucket.this.arn
    }
  )
}

# 各IAMロールのユニークID確認
data "aws_iam_role" "infra_rw_role" {
  name = "infra-rw-role"
}
data "aws_iam_role" "infra_terraform_role" {
  name = "infra-terraform-role"
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = templatefile(
    "${path.module}/files/bucket-policy.yml",
    {
      bucket_arn        = aws_s3_bucket.this.arn,
      switch_role_id    = data.aws_iam_role.infra_rw_role.unique_id,
      terraform_role_id = data.aws_iam_role.infra_terraform_role.unique_id,
      user_arn          = aws_iam_user.this.arn
    }
  )
}
