# Quick Setup Guide - CS2 Server on AWS

> **To deploy the infra** Check out [DEPLOYMENT.md](DEPLOYMENT.md) for deploying servers using Terraform Workspaces!

### 1. Prerequisites

#### 1.1 Create SSH Key in AWS
```bash
# In AWS console or via CLI
aws ec2 create-key-pair \
  --key-name cs2server \
  --query 'KeyMaterial' \
  --output text > ~/.ssh/cs2server.pem

chmod 400 ~/.ssh/cs2server.pem
```

> **Important**: If you want to use a different key name, update the `ssh_key_pair` variable in `variables.tf`

#### 1.2 Generate Steam GSLT Token

1. Go to: https://steamcommunity.com/dev/managegameservers
2. Log in with your Steam account
3. Click "Create a new game server account"
4. Fill in:
   - **App ID**: `730` (Counter-Strike 2)
   - **Memo**: `CS2 AWS Server` (or your preferred description)
5. Copy the generated token (format: `XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`)
6. Update the `gslt_token` variable in `variables.tf`

> **Important**: Each GSLT can only be used on one server at a time. If you have multiple servers, you need multiple tokens.

### 3. Validate AMI (EC2 Image)

The default AMI in `variables.tf` may be outdated.

```bash
aws ssm get-parameter \
  --name "/aws/service/canonical/ubuntu/server/22.04/stable/current/amd64/hvm/ebs-gp2/ami-id" \
  --region <YOUR_REGION> \
  --query "Parameter.Value" \
  --output text
```

Update `image_id` in `variables.tf` with the returned ID (e.g., `ami-0c1234567890abcdef`).

#### Connect via SSH:
```bash
ssh -i ~/.ssh/<YOUR_KEY_PAIR_FILE>.pem ubuntu@<PUBLIC_IP>
```

or you can access via putty on windows.  

#### Check installation progress:
```bash
# Cloud-init logs (user data)
```
sudo tail -f /var/log/cloud-init-output.log
```
or to show the complete log
```
sudo less /var/log/cloud-init.log
```

# After installation completes
./cs2server details
./cs2server console  # CTRL+B followed by D to exit (tmux)
```

### 5. Test Server

#### In CS2 client:

1. Open CS2 console (`~` key)
2. Type: `connect <PUBLIC_IP>:27015`

Or add to favorites in the server browser.

#### Test RCON:
```bash
# On server via SSH
./cs2server console

# Inside console:
status
users
changelevel de_dust2
```

### 6. Post-Deploy Configuration

#### 6.1 Configure Maps and Game Modes

SSH into the instance and edit:
```bash
nano /home/ubuntu/serverfiles/cs2/game/csgo/cfg/cs2server.cfg
```

Add:
```
// Maps
host_workshop_collection <COLLECTION_ID>  // Steam Workshop ID
mapgroup mg_active                         // Or your custom mapgroup

// Game mode
game_type 0
game_mode 1  // 0=casual, 1=competitive
```

Restart:
```bash
./cs2server restart
```

#### 6.2 Add Admins

Edit server config:
```bash
nano /home/ubuntu/serverfiles/cs2/game/csgo/cfg/cs2server.cfg
```

Add:
```
// Admins via SteamID
// Format: rcon_password for full control
```

#### Manual Commands:
```bash
./cs2server update    # Update server
./cs2server restart   # Restart
./cs2server stop      # Stop
./cs2server start     # Start
./cs2server monitor   # Check if running
```

### 8. Additional Resources

- [LinuxGSM CS2 Docs](https://docs.linuxgsm.com/game-servers/counter-strike-2)
- [CS2 Server Commands](https://totalcsgo.com/commands)
- [Steam Workshop](https://steamcommunity.com/app/730/workshop/)
