output "instance_id" {
  description = "ID of the EC2 instance"
  value       = aws_instance.commander_instance.id
}

output "instance_public_ip" {
  description = "Public IP address of the EC2 instance"
  value       = aws_eip.eip_commander.public_ip
}

output "security_group_id" {
  description = "ID of the security group"
  value       = aws_security_group.network-security-group.id
}