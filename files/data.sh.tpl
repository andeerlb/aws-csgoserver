#!/bin/bash

# ===============================
# Counter-Strike 2 Server Setup
# OS: Ubuntu 22.04 LTS
# ===============================

# -------------------------------
# Set the user
# -------------------------------
USER="ubuntu"

# -------------------------------
# Update system and install required packages
# Includes 32-bit libraries needed for SteamCMD
# -------------------------------
sudo apt update -y
sudo dpkg --add-architecture i386
sudo apt update -y

sudo apt install -y \
  curl wget tar bzip2 gzip unzip python3 \
  lib32gcc-s1 lib32stdc++6 libc6-i386 libc6:i386 \
  tmux jq bc

# -------------------------------
# Move to the user's home directory
# -------------------------------
cd /home/$USER/

# -------------------------------
# Download and prepare LinuxGSM installer
# -------------------------------
wget -O /home/$USER/linuxgsm.sh https://linuxgsm.sh
chmod +x /home/$USER/linuxgsm.sh

# -------------------------------
# Install CS2 server using LinuxGSM
# -------------------------------
su - $USER -c "bash /home/$USER/linuxgsm.sh cs2server"

# -------------------------------
# Auto-install CS2 server
# -------------------------------
su - $USER -c "/home/$USER/cs2server auto-install"

# -------------------------------
# Configure GSLT token and tickrate
# -------------------------------
if [ -d "/home/$USER/lgsm/config-lgsm/cs2server" ]; then
  echo "gslt=\"${GSLT_TOKEN}\"" >> /home/$USER/lgsm/config-lgsm/cs2server/cs2server.cfg
  echo "tickrate=\"128\"" >> /home/$USER/lgsm/config-lgsm/cs2server/cs2server.cfg
  echo "defaultmap=\"de_dust2\"" >> /home/$USER/lgsm/config-lgsm/cs2server/cs2server.cfg
fi

# -------------------------------
# Create CS2 server configuration directory
# -------------------------------
mkdir -p /home/$USER/serverfiles/game/csgo/cfg

# -------------------------------
# Write server configuration file
# -------------------------------
cat <<EOT > /home/$USER/serverfiles/game/csgo/cfg/cs2server.cfg
hostname "${SERVER_NAME}"
rcon_password "${RCON_PASSWD}"
sv_password ""
sv_contact "andeerlbdev@gmail.com"
sv_lan 0
sv_cheats 0
sv_tags "128-tick"
sv_region 2
log on
sv_logbans 1
sv_logecho 1
sv_logfile 1
sv_log_onefile 0
sv_hibernate_when_empty 1
sv_hibernate_ms 5
exec banned_user.cfg
exec banned_ip.cfg
writeid
writeip
EOT

# -------------------------------
# Set proper permissions for LGSM and server files
# -------------------------------
sudo chown -R $USER:$USER /home/$USER/serverfiles
sudo chown -R $USER:$USER /home/$USER/lgsm

# -------------------------------
# Setup cron jobs for automatic update and server monitoring
# -------------------------------
# Backup current user crontab and append new jobs
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
