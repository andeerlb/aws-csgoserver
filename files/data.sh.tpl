#!/bin/bash

USER="ec2-user"

# Update system and install dependencies for CS2
yum update -y
amazon-linux-extras install epel -y
yum install curl wget tar bzip2 gzip unzip python3 binutils bc jq tmux glibc.i686 libstdc++ libstdc++.i686 -y

cd /home/$USER/

# Install LinuxGSM
wget -O /home/$USER/linuxgsm.sh https://linuxgsm.sh 
chmod +x /home/$USER/linuxgsm.sh

# Install CS2 server using LinuxGSM (cs2server instead of csgoserver)
su - $USER -c "bash /home/$USER/linuxgsm.sh cs2server"

# Auto-install CS2 server
su - $USER -c "/home/$USER/cs2server auto-install"

# Configure GSLT token and tickrate for CS2
if [ -d "/home/$USER/lgsm/config-lgsm/cs2server" ]; then
  echo "gslt=\"${GSLT_TOKEN}\"" >> /home/$USER/lgsm/config-lgsm/cs2server/cs2server.cfg
  echo "tickrate=\"128\"" >> /home/$USER/lgsm/config-lgsm/cs2server/cs2server.cfg
fi

# Create CS2 server configuration
mkdir -p /home/$USER/serverfiles/cs2/game/csgo/cfg
cat <<EOT > /home/$USER/serverfiles/cs2/game/csgo/cfg/cs2server.cfg
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

# Set proper permissions
sudo chown -R $USER:$USER /home/$USER/serverfiles
sudo chown -R $USER:$USER /home/$USER/lgsm

# Setup cron jobs for auto-update and monitoring
echo "0 * * * * su - $USER -c '/home/$USER/cs2server update'" >> /home/$USER/crontab_file
echo "*/5 * * * *  su - $USER -c '/home/$USER/cs2server monitor'" >> /home/$USER/crontab_file

crontab "/home/$USER/crontab_file"
rm /home/$USER/crontab_file

# Update and start CS2 server
su - $USER -c "/home/$USER/cs2server update"
su - $USER -c "/home/$USER/cs2server start"