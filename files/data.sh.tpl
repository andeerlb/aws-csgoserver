#!/bin/bash

# ===============================
# Counter-Strike 2 Server Setup
# OS: Ubuntu 22.04 LTS
# ===============================

USER="ubuntu"

# -------------------------------
# Update system and install required packages
# -------------------------------
sudo apt update -y
sudo dpkg --add-architecture i386
sudo apt update -y

sudo apt install -y \
  curl wget tar bzip2 gzip unzip python3 \
  lib32gcc-s1 lib32stdc++6 libc6-i386 libc6:i386 \
  tmux jq bc awscli

# -------------------------------
# Move to user's home directory
# -------------------------------
cd /home/$USER/

# -------------------------------
# Restore from S3 backup if exists
# -------------------------------
BACKUP_FILE="cs2-server-backup.tar.gz"

# -------------------------------
# Restore from S3 backup if exists
# -------------------------------
S3_SERVERFILES_BACKUP="${S3_SERVERFILES_BACKUP}"
BACKUP_FILE="cs2-server-backup.tar.gz"
LOCAL_TMP="/tmp/$BACKUP_FILE"
SERVERFILES_DIR="/home/$USER/serverfiles"

echo ""
echo "-------------------------------"
echo "Checking for existing backup in S3..."
echo "S3 Bucket: ${S3_SERVERFILES_BACKUP}"
echo "Backup File: $BACKUP_FILE"
echo ""

echo ""
echo "-------------------------------"
echo "Checking for existing backup in S3..."
echo "S3 Bucket: ${S3_SERVERFILES_BACKUP}"
echo "Backup File: $BACKUP_FILE"
echo ""

# Check if backup exists in S3
if aws s3 ls "s3://${S3_SERVERFILES_BACKUP}/$BACKUP_FILE" >/dev/null 2>&1; then
    echo "Found backup file in S3, downloading..."

    # Download backup (Transfer Acceleration automatic if enabled)
    aws s3 cp "s3://${S3_SERVERFILES_BACKUP}/$BACKUP_FILE" "$LOCAL_TMP"

    # Verify download succeeded
    if [ ! -f "$LOCAL_TMP" ]; then
        echo "Error: Backup download failed. Exiting."
        exit 1
    fi

    # Ensure serverfiles directory exists
    mkdir -p "$SERVERFILES_DIR"

    # Extract backup
    echo "Extracting backup to $SERVERFILES_DIR..."
    tar -xzf "$LOCAL_TMP" -C "$SERVERFILES_DIR"

    # Fix permissions
    chown -R $USER:$USER "$SERVERFILES_DIR"

    # Cleanup
    rm -f "$LOCAL_TMP"

    echo "Backup restored successfully!"
else
    echo "No backup found in S3, proceeding with fresh install..."
fi
echo "-------------------------------"
echo ""

# -------------------------------
# Download LinuxGSM
# -------------------------------
wget -O linuxgsm.sh https://linuxgsm.sh
chmod +x linuxgsm.sh

# -------------------------------
# Install CS2 server using LinuxGSM
# -------------------------------
su - $USER -c "bash linuxgsm.sh cs2server"

# -------------------------------
# Auto-install CS2 server
# -------------------------------
su - $USER -c "/home/$USER/cs2server auto-install"

# -------------------------------
# Configure LGSM (GSLT, tickrate, default map, start parameters)
# -------------------------------
CONFIG_FILE="/home/$USER/lgsm/config-lgsm/cs2server/_default.cfg"

if [ -f "$CONFIG_FILE" ]; then
  # Set correct values
  sed -i "s|^startparameters=.*|startparameters=\"-dedicated -ip $\{ip} -port $\{port} -maxplayers $\{maxplayers} -authkey $\{wsapikey} +exec $\{selfname}.cfg -tickrate 128 +map de_dust2 +sv_setsteamaccount ${GSLT_TOKEN}\"|" "$CONFIG_FILE"
fi
# -------------------------------
# Create CS2 server configuration directory if missing
# -------------------------------
mkdir -p /home/$USER/serverfiles/game/csgo/cfg

# -------------------------------
# Write CS2 main server configuration file
# -------------------------------
cat <<EOT > /home/$USER/serverfiles/game/csgo/cfg/cs2server.cfg
hostname "${SERVER_NAME}"
rcon_password "${RCON_PASSWD}"
sv_password "${SERVER_PASSWD}"
sv_contact "andeerlbdev@gmail.com"
sv_lan 0
sv_cheats 0
sv_tags "128-tick"
sv_region 5
log on
sv_logbans 1
sv_logecho 1
sv_logfile 1
sv_log_onefile 0
sv_hibernate_when_empty 1
sv_hibernate_ms 5
sv_mincmdrate 128
sv_minupdaterate 128
bot_quota 0
bot_quota_mode fill
bot_kick
exec banned_user.cfg
exec banned_ip.cfg
writeid
writeip
EOT

# -------------------------------
# Fix ownership and permissions
# -------------------------------
sudo chown -R $USER:$USER /home/$USER/serverfiles
sudo chown -R $USER:$USER /home/$USER/lgsm

# -------------------------------
# Setup cron jobs for auto-update and monitoring
# -------------------------------
crontab -u $USER -l > /home/$USER/crontab_file 2>/dev/null || true
echo "0 * * * * /home/$USER/cs2server update" >> /home/$USER/crontab_file
echo "*/5 * * * * /home/$USER/cs2server monitor" >> /home/$USER/crontab_file
crontab -u $USER /home/$USER/crontab_file
rm /home/$USER/crontab_file

# -------------------------------
# Update and start CS2 server
# -------------------------------
su - $USER -c "/home/$USER/cs2server update"
su - $USER -c "/home/$USER/cs2server start"