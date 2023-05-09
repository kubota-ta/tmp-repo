variable "name" {
  description = "リソース名"
}

variable "tags" {
  description = "タグ"
}

variable "lifecycle_rule" {
  description = "ライフサイクルルール（期限削除）"
  default = {
    elb        = 14,
    cloudfront = 14,
  }
}
