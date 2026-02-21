# Outputs
output "bastion_ip" {
  value = aws_instance.bastion.public_ip
}

output "app_private_ip" {
  value = aws_instance.app.private_ip
}

output "db_endpoint" {
  value = aws_db_instance.postgres.endpoint
}