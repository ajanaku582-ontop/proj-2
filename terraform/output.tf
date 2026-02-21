# Outputs
output "app_node_ip" {
  value = aws_instance.app.public_ip
}

output "Bastion_node_ip" {
  value = aws_instance.bastion.public_ip
}
