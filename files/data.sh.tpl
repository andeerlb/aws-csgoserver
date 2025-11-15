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
  tmux jq bc

# -------------------------------
# Move to user's home directory
# -------------------------------
cd /home/$USER/

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
CONFIG_FILE="/home/$USER/lgsm/config-lgsm/cs2server/cs2server.cfg"

if [ -f "$CONFIG_FILE" ]; then
  # Remove old values to avoid duplicates
  sed -i "/^gslt=/d" "$CONFIG_FILE"
  sed -i "/^tickrate=/d" "$CONFIG_FILE"
  sed -i "/^defaultmap=/d" "$CONFIG_FILE"
  sed -i "/^startparameters=/d" "$CONFIG_FILE"

  # Set correct values
  echo "startparameters=\"-dedicated -ip 0.0.0.0 -port 27015 -tickrate 128 -maxplayers 16 -authkey +exec cs2server.cfg +map de_dust2 +sv_setsteamaccount ${GSLT_TOKEN}\"" >> "$CONFIG_FILE"
fi
# -------------------------------
# Create CS2 server configuration directory if missing
# -------------------------------
mkdir -p /home/$USER/serverfiles/game/csgo/cfg

# -------------------------------
# Write CS2 main server configuration file
# -------------------------------
cat <<EOT > /home/$USER/serverfiles/game/csgo/cfg/cs2server.cfg
hostname "${SERVER_NAME}"       # Server name
rcon_password "${RCON_PASSWD}"  # RCON password for remote console
sv_password ""                  # Server password (empty = public)
sv_contact "andeerlbdev@gmail.com"
sv_lan 0                        # 0 = public, 1 = LAN only
sv_cheats 0                     # Disable cheats
sv_tags "128-tick"
sv_region 5                      # 5 = Brazil
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