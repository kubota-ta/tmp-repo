output "task" {
  value = {
    arn = aws_iam_role.task.arn
  }
}

output "task_exec" {
  value = {
    arn = aws_iam_role.task_exec.arn
  }
}
