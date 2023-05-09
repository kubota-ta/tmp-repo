output "x-pre-shared-key" {
  description = "カスタムヘッダの値"
  value       = random_password.x-pre-shared-key.result
  sensitive   = true
}
