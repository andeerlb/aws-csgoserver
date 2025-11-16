# Output all servers information
output "servers" {
  description = "Information about all deployed CS2 servers"
  value = {
    for key, server in var.servers : key => {
      server_name      = server.server_name
      asg_id           = aws_autoscaling_group.cs2[key].id
      launch_template  = aws_launch_template.cs2[key].name
      rcon_password    = server.rcon_passwd
      server_password  = server.server_passwd
      ssh_key          = server.ssh_key_pair
    }
  }
}

# Output to get IPs for all servers
output "connection_commands" {
  description = "AWS CLI commands to get public IPs for all servers"
  value = {
    for key, server in var.servers : key => <<-EOT
    
    ==========================================
    Server: ${server.server_name} (${key})
    ==========================================
    
    Get IP:
    aws ec2 describe-instances \
      --filters "Name=tag:ServerKey,Values=${key}" "Name=instance-state-name,Values=running" \
      --query 'Reservations[0].Instances[0].PublicIpAddress' \
      --output text \
      --region sa-east-1
    
    SSH (replace <IP> with actual IP):
    ssh -i ~/.ssh/${server.ssh_key_pair}.pem ubuntu@<IP>
    
    Connect in CS2:
    connect <IP>:27015
    
    RCON Password: ${server.rcon_passwd}
    Server Password: ${server.server_passwd == "" ? "Not set" : server.server_passwd}
    
    EOT
  }
}

output "security_group_id" {
  description = "Shared Security Group ID for all CS2 servers"
  value       = aws_security_group.cs2.id
}

output "vpc_id" {
  description = "Shared VPC ID for all CS2 servers"
  value       = module.vpc_cs2.id
}

output "region" {
  description = "AWS region where servers are deployed"
  value       = "sa-east-1"
}
