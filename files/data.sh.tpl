#!/bin/bash

USER="ec2-user"

yum update -y
amazon-linux-extras install epel -y
yum install curl wget tar bzip2 gzip unzip python3 binutils bc jq tmux glibc.i686 libstdc++ libstdc++.i686 -y

wget -O /home/$USER/linuxgsm.sh https://linuxgsm.sh 
chmod +x /home/$USER/linuxgsm.sh

cd /home/$USER/

su $USER -s ./linuxgsm.sh csgoserver

# su $USER -s ./csgoserver auto-install

# echo gslt=\"${GSLT_TOKEN}\" >> /home/$USER/lgsm/config-lgsm/csgoserver/csgoserver.cfg
# echo "tickrate=\"128\"" >> /home/$USER/lgsm/config-lgsm/csgoserver/csgoserver.cfg

# echo "sv_mincmdrate 128" >> /home/$USER/serverfiles/csgo/cfg/csgoserver.cfg
# echo "sv_minupdaterate 128" >> /home/$USER/serverfiles/csgo/cfg/csgoserver.cfg

# cat <<EOT > /home/$USER/serverfiles/csgo/cfg/csgoserver.cfg
# hostname "${SERVER_NAME}"
# rcon_password "${RCON_PASSWD}"
# sv_password ""
# sv_contact "andeerlbdev@gmail.com"
# sv_lan 0
# sv_cheats 0
# sv_tags "128-tick"
# sv_region 2
# log on
# sv_logbans 1
# sv_logecho 1
# sv_logfile 1
# sv_log_onefile 0
# sv_hibernate_when_empty 1
# sv_hibernate_ms 5
# host_name_store 1
# host_info_show 1
# host_players_show 2
# exec banned_user.cfg
# exec banned_ip.cfg
# writeid
# writeipa
# EOT

# su $USER -s crontab -l > /home/$USER/csgoserver_update
# su $USER -s crontab -l > /home/$USER/csgoserver_monitor

# echo "0 * * * * su - $USER -c '/home/$USER/csgoserver update'" > /home/$USER/csgoserver_update
# echo "*/5 * * * *  su - $USER -c '/home/$USER/csgoserver monitor'" > /home/$USER/csgoserver_monitor

# crontab /home/$USER/csgoserver_update
# crontab /home/$USER/csgoserver_monitor

# rm /home/$USER/csgoserver_updateecho
# rm /home/$USER/csgoserver_monitor

# su $USER -s ./csgoserver update
# su $USER -s ./csgoserver start