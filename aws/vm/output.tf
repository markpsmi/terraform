output "ip_address" {
  description = "IP address of our new instance"
  value       = aws_instance.example.public_ip
}