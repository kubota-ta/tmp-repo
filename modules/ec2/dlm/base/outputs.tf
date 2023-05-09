output "iam_role" {
  value = {
    for_snapshot = aws_iam_role.for_snapshot.arn
    for_ami      = aws_iam_role.for_ami.arn
  }
}

output "iam_policy" {
  value = {
    for_snapshot = [
      aws_iam_policy.this["AWSDataLifecycleManagerServiceRole"].arn
    ]
    for_ami = [
      aws_iam_policy.this["AWSDataLifecycleManagerServiceRoleForAMIManagement"].arn
    ]
  }
}
