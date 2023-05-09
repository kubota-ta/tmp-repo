# S3 Bucket CloudFront Origin 向け

CloudFront Origin として利用する Bucket を作成します  
付随して、OriginAccessIdentity の作成と設定 (BucketPolicy) 及び CORS の設定も行います


## 作られるもの

| ResourceType     | Name                         |
|----              |----                          |
| CloudFrontOAI    | (env.prefix)-(name)          |
| S3Bucket         | (env.prefix)-(name)          |

## methodとheaderについて
CORS設定の際に、別途指定が必要な場合がありましたので、バケット別で設定できるようにしました。
--
variable "allowed_headers" {
  description = "AllowedHeaders"
  default     = ["Authorization"]
}

variable "methods" {
  description = "AllowedMethods"
  default     = ["GET", "HEAD"]
}
--
デフォルトではもともと設定していた値が入るようになっています。
バケット別で指定したい場合は、作成のほうで
--
module "s3-tellme" {
  source = "../../../modules/s3/bucket/restapi-origin"
  env    = module.env
  name   = "tellme"
  allowed_headers = ["*"]
}
--
上記のようにheaderやmethodを指定してください。