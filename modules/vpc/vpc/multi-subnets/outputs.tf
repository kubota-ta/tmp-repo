output "vpc_id" {
  description = "VPCのID"
  value       = aws_vpc.this.id
}

output "subnet_front_ids" {
  description = "frontサブネットのID"
  value = [
    for k, v in local.subnets.zones : aws_subnet.public["front-${k}"].id
  ]
}

output "subnet_elb_ids" {
  description = "elbサブネットのID"
  value = [
    for k, v in local.subnets.zones : aws_subnet.public["elb-${k}"].id
  ]
}

output "subnet_web_ids" {
  description = "webサブネットのID"
  value = [
    for k, v in local.subnets.zones : aws_subnet.private["web-${k}"].id
  ]
}

output "subnet_private_ids" {
  description = "privateサブネットのID"
  value = [
    for k, v in local.subnets.zones : aws_subnet.private["private-${k}"].id
  ]
}

output "subnet_all_ids" {
  description = "全サブネットID"
  value = merge({
    for k, v in aws_subnet.public : k => v.id
    }, {
    for k, v in aws_subnet.private : k => v.id
  })
}
