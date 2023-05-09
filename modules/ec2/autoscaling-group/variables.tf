variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "image_id" {
  description = "AMI ID"
  default     = null
}

## >> create ami from origin
variable "origin_id" {
  description = "origin instance id"
  default     = null
}

variable "ami_retention" {
  default = 30
}

variable "ami_index" {
  default = 0
}
## << create ami from origin

variable "instance_type" {
  description = "Instance Type"
  default     = "s3.nano"
}

variable "iam_instance_profile" {
  description = "IAM instance profile"
}

variable "security_groups" {
  description = "SecurityGroup IDs"
  default     = []
}

variable "subnet_ids" {
  description = "Subnet IDs"
  default     = []
}

variable "target_group_arns" {
  description = "TargetGroup IDs"
  default     = []
}

variable "desired_capacity" {
  description = "Desired capacity"
  default     = 0
}

variable "min_size" {
  description = "Minimum capacity"
  default     = 0
}

variable "max_size" {
  description = "Maximum capacity"
  default     = 0
}

variable "user_data" {
  description = "UserData"
  default     = null
}

variable "default_version" {
  description = "Launch template version ( -1: no change, 0: update, 1-: specified)"
  default     = -1
}
