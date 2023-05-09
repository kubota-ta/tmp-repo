output "x-pre-shared-key" {
  description = "カスタムヘッダの値"
  value       = { for k, v in random_password.x-pre-shared-key : k => v.result }
  sensitive   = true
}
