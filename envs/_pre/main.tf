/**
 * terraform settings
 */
provider "aws" {
  region  = var.region
  profile = var.aws_profile
}

/**
 * main
 */
#
# terraform tfstateファイル記録用バケット
#
resource "aws_s3_bucket" "tf_backend" {
  bucket = format("%s-tfstate", var.name)
}

resource "aws_s3_bucket_acl" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  acl    = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_versioning" "tf_backend" {
  bucket = aws_s3_bucket.tf_backend.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "tf_backend" {
  bucket                  = aws_s3_bucket.tf_backend.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

#
# EC2 common key-pair
#
#resource "aws_key_pair" "pj_keypair" {
#  key_name   = "keypair-tokyo"
#  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCW+1K8kQ6DGdRJVMnac/VATHJFdO62Wh/DnW5NXLLPsjvAphFo6yySEjpeTH15KWVRhphGSa0E1ouUQR5/skHNg2Nr5FGU35l4jDxKQH4+wavMx5wgKe7BsqrWZf5YR/71FQ5SDSKQ0ODkw0PD8sNW8IEJEoWlTbgw3IvxNEdYXRVAIwWxJQZPEgt9YFNRYdwbNC573uGsnmSjrqy6/zlq6t4YsuF1TjGHp8DvMb7iTNPkqsEnDL05/gMvXvCbgAkVmYu3PmJYN+JPqrQkqhBeD10gF51/oI+T5OZYsZNGjx9wZLOh2szO021lca1d4ZYHQ9swxxXGtaD4ElOXXr81 keypair-tokyo.pem"
#  lifecycle {
#    ignore_changes = [public_key]
#  }
#}

