output "public_ip" {
  value = { (var.name) = aws_instance.this[0].public_ip }
}

output "instance_id" {
  value = { (var.name) = aws_instance.this[0].id }
}

output "instance_profile" {
  value = { (var.name) = module.ec2_role.iam_role }
}

