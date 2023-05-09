output "image_id" {
  value = aws_ami_from_instance.this[var.ami_index].id
}
