# Multi-Server Setup with Terraform Workspaces

This guide explains how to deploy multiple CS2 servers using Terraform Workspaces. Each workspace creates a separate EC2 instance that shares the same VPC and Security Group.

## Architecture

- **Shared Infrastructure**: VPC and Security Group (created once)
- **Per Server**: Separate EC2 instance, Auto Scaling Group, IAM resources
- **Workspace `default`**: Server 1
- **Workspace `server2`**: Server 2
- **Workspace `server3`**: Server 3
- ...and so on

Each server gets:
- Separate EC2 instance
- Separate Auto Scaling Group
- Separate IAM instance profile
- Independent configuration
- **Shared VPC** (cs2-shared-network)
- **Shared Security Group** (cs2-shared-gameserver-sg)
- Shared state bucket with separate state files

## Prerequisites

1. **AWS Credentials** configured
2. **S3 Bucket** for Terraform state
3. **SSH Key Pair** created in AWS
4. **One GSLT token per server** from https://steamcommunity.com/dev/managegameservers

## Initial Setup (First Time Only)

```bash
# Initialize Terraform
terraform init

# Verify current workspace (should be 'default')
terraform workspace list

# IMPORTANT: Deploy shared infrastructure first (VPC + Security Group)
# This happens automatically when you deploy server 1
```

## Deploy Server 1 (Default Workspace)

```bash
# Make sure you're in default workspace
terraform workspace select default

# Edit variables.tf or create default.tfvars:
# - server_name = "YOUR_SERVER_NAME"
# - gslt_token = "YOUR_TOKEN"
# - rcon_passwd = "YOUR_RCON_PASSWD"

# Deploy
terraform apply
```

## Deploy Server 2

### Step 1: Create variables file

Create `server2.tfvars`:
```hcl
server_name = "SERVER_NAME"
gslt_token  = "YOUR_TOKEN_2_HERE"
rcon_passwd = "PASSWORD"
```

### Step 2: Create workspace and deploy

```bash
# Create workspace for server 2
terraform workspace new server2

# Deploy server 2
terraform apply -var-file="server2.tfvars"
```

## Deploy Server 3, 4, 5... (Unlimited)

### For each additional server:

1. **Generate new GSLT token** at https://steamcommunity.com/dev/managegameservers
   - App ID: `730`
   - Memo: `Server 3`, `Server 4`, etc.

2. **Create variables file** (e.g., `server3.tfvars`):
```hcl
server_name = "SERVER_NAME_3"
gslt_token  = "YOUR_TOKEN_3_HERE"
rcon_passwd = "password3"
```

3. **Create workspace and deploy**:
```bash
terraform workspace new server3
terraform apply -var-file="server3.tfvars"
```

## Managing Servers

### List all servers (workspaces)
```bash
terraform workspace list
```

### Switch between servers
```bash
# Switch to server 1
terraform workspace select default

# Switch to server 2
terraform workspace select server2

# Switch to server 3
terraform workspace select server3
```

### View server details
```bash
# Select the workspace first
terraform workspace select server2

# Show outputs (IP, connection info, etc.)
terraform output

# Get specific output
terraform output connection_info
```

### Update a specific server
```bash
# Select workspace
terraform workspace select server2

# Make changes to .tf files or variables

# Apply with correct var file
terraform apply -var-file="server2.tfvars"
```

### Destroy a specific server
```bash
# Select workspace
terraform workspace select server3

# Destroy only server 3
terraform destroy -var-file="server3.tfvars"

# Delete workspace (optional, after destroy)
terraform workspace select default
terraform workspace delete server3
```

## Important Notes

1. **Each server needs a unique GSLT token** - You cannot reuse tokens
2. **Each server needs a unique server_name** - This is used for EC2 instance naming
3. **VPC and Security Group are shared** - Created once, used by all servers
4. **Always use `-var-file` when managing non-default workspaces** - Ensures correct variables
5. **Destroy servers when not needed** - Save costs by destroying unused servers
6. **Destroying server 1 (default) will NOT destroy VPC/SG** - They use lifecycle ignore_changes