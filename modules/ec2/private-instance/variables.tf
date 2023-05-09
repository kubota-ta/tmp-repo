variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "ami" {
  description = "AMI ID"
  default     = null
}

variable "instance_type" {
  description = "インスタンスタイプ"
  default     = "t2.micro"
}

variable "volume_size" {
  description = "ルートボリュームサイズ"
  default     = 8
}

variable "vpc_security_group_ids" {
  description = "セキュリティグループ"
}

variable "subnet_ids" {
  description = "使用可能なSubnetのリスト"
}

