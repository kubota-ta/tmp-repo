variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "allowed_headers" {
  description = "AllowedHeaders"
  default     = ["Authorization"]
}

variable "methods" {
  description = "AllowedMethods"
  default     = ["GET", "HEAD"]
}

variable "origins" {
  description = "AllowedOrigins"
  default     = ["*"]
}

variable "max_age_seconds" {
  description = "MaxAgeSeconds"
  default     = 3000
}
