output "cert" {
  description = "SSL証明書"
  value       = aws_acm_certificate.this
}
