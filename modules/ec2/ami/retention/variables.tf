variable "env" {
  description = "環境変数"
}

variable "origin_id" {
  description = "origin instance id"
}

variable "ami_retention" {
  default = 30
}

variable "ami_index" {
  default = 0
}
