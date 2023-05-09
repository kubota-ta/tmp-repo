output "arn" {
  description = "LB arn"
  value       = aws_lb.this.arn
}

output "dns_name" {
  description = "LB DNS name"
  value       = aws_lb.this.dns_name
}

