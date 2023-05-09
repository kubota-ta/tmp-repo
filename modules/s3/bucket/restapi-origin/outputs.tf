output "id" {
  value = module.s3_bucket.bucket.id
}

output "bucket_regional_domain_name" {
  value = module.s3_bucket.bucket.bucket_regional_domain_name
}

output "cloudfront_access_identity_path" {
  value = aws_cloudfront_origin_access_identity.this.cloudfront_access_identity_path
}

