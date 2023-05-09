variable "env" {
  description = "環境変数"
}

variable "name" {
  description = "リソース名"
}

variable "instance_id" {
  description = "インスタンスID"
}

variable "size" {
  description = "ボリュームサイズ(GB)"
}

variable "device_name" {
  description = "デバイス名"

  # 推奨されるデバイス名
  # https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/device_naming.html

  default = "/dev/xvdf"
}
