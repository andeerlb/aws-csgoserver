output "instance_id" {
  description = "EC2 instance ID of the CS2 server"
  value       = try(aws_autoscaling_group.cs2.id, "Waiting for creation...")
}

output "server_name" {
  description = "CS2 server name"
  value       = var.server_name
}

output "connection_info" {
  description = "CS2 server connection information"
  value       = <<-EOT
  
  ==========================================
  CS2 Server: ${var.server_name}
  ==========================================
  
  To get the instance public IP:
  aws ec2 describe-instances \
    --filters "Name=tag:Name,Values=${local.name_with_prefix}" "Name=instance-state-name,Values=running" \
    --query 'Reservations[0].Instances[0].PublicIpAddress' \
    --output text \
    --region sa-east-1
  
  SSH:
  ssh -i ~/.ssh/${var.ssh_key_pair}.pem ec2-user@<PUBLIC_IP>
  
  Connect in CS2:
  connect <PUBLIC_IP>:27015
  
  RCON Password: ${var.rcon_passwd}
  
  EOT
}

output "important_commands" {
  description = "Important commands to manage the server"
  value       = <<-EOT
  
  ==========================================
  Useful Server Commands
  ==========================================
  
  ./cs2server start      - Start server
  ./cs2server stop       - Stop server
  ./cs2server restart    - Restart server
  ./cs2server details    - View details
  ./cs2server console    - Access console (Ctrl+B D to exit)
  ./cs2server update     - Update server
  ./cs2server monitor    - Check status
  
  Logs:
  sudo tail -f /home/ec2-user/lgsm/log/cs2server/console/cs2server-console.log
  
  EOT
}

output "security_group_id" {
  description = "Security Group ID of the CS2 server"
  value       = aws_security_group.cs2.id
}

output "vpc_id" {
  description = "VPC ID of the CS2 server"
  value       = module.vpc_cs2.id
}

output "region" {
  description = "AWS region where the server is deployed"
  value       = "sa-east-1"
}
