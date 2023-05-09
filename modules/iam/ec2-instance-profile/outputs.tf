output "iam_role" {
  value = {
    role    = aws_iam_role.this.name
    profile = aws_iam_instance_profile.this.name
  }
}

output "iam_role_arn" {
  value = {
    role    = aws_iam_role.this.arn
    profile = aws_iam_instance_profile.this.arn
  }
}
