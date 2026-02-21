# Outputs
# --- Connection Info ---

output "bastion_public_ip" {
  value       = aws_instance.bastion.public_ip
  description = "The public IP of the Bastion host for SSH access."
}

output "app_private_ip" {
  value       = aws_instance.app.private_ip
  description = "The private IP of the App server (use this to SSH from Bastion)."
}

output "database_endpoint" {
  value       = aws_db_instance.postgres.address
  description = "The connection endpoint for the RDS Postgres instance."
}

output "database_port" {
  value = aws_db_instance.postgres.port
}