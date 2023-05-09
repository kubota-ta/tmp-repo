variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "description" {
  description = "説明"
  default     = null
}

variable "image_id" {
  description = "AMI ID"
  default     = null
}

variable "instance_type" {
  description = "Instance Type"
  default     = "t3.micro"
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
}

variable "subnet_id" {
  description = "VPC Subnet ID"
}

variable "security_groups" {
  description = "SecurityGroup IDs"
  default     = []
}

variable "user_data" {
  description = "UserData"
  default     = null
}

variable "default_version" {
  description = "Launch template version ( -1: no change, 0: update, 1-: specified)"
  default     = -1
}
