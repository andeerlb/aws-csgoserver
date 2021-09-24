#!/bin/bash

USER="ec2-user"

yum update -y
amazon-linux-extras install epel -y
yum install curl wget tar bzip2 gzip unzip python3 binutils bc jq tmux glibc.i686 libstdc++ libstdc++.i686 -y

wget -O /home/$USER/linuxgsm.sh https://linuxgsm.sh 
chmod +x /home/$USER/linuxgsm.sh

cd /home/$USER/

su $USER -s ./linuxgsm.sh csgoserver

aws s3 cp s3://csgoserver/backup-default-server/backup-default-server.zip .
aws s3 cp s3://csgoserver/backup-default-server/sourcemod-1.10.0-git6514-linux.tar.gz .
aws s3 cp s3://csgoserver/backup-default-server/mmsource-1.11.0-git1145-linux.tar.gz .
#aws s3 cp s3://csgoserver/backup-default-server/get5_0.7.2.zip .

unzip -q -o backup-default-server.zip -d /home/$USER/
#unzip -q -o get5_0.7.2.zip -d /home/$USER/serverfiles/csgo/   
tar -xf sourcemod-1.10.0-git6514-linux.tar.gz -C /home/$USER/serverfiles/csgo/
tar -xf mmsource-1.11.0-git1145-linux.tar.gz -C /home/$USER/serverfiles/csgo/

rm -f backup-default-server.zip
rm -f sourcemod-1.10.0-git6514-linux.tar.gz
rm -f mmsource-1.11.0-git1145-linux.tar.gz
#rm -rf get5

sudo chown -R $USER:$USER /home/$USER/serverfiles

su $USER -s ./csgoserver auto-install

echo "\"STEAM_1:0:119601991\"		\"5:z\"" >> /home/$USER/serverfiles/csgo/addons/sourcemod/configs/admins_simple.ini

echo gslt=\"${GSLT_TOKEN}\" >> /home/$USER/lgsm/config-lgsm/csgoserver/csgoserver.cfg
echo "tickrate=\"128\"" >> /home/$USER/lgsm/config-lgsm/csgoserver/csgoserver.cfg

echo "sv_mincmdrate 128" >> /home/$USER/serverfiles/csgo/cfg/csgoserver.cfg
echo "sv_minupdaterate 128" >> /home/$USER/serverfiles/csgo/cfg/csgoserver.cfg

cat <<EOT > /home/$USER/serverfiles/csgo/cfg/csgoserver.cfg
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
host_name_store 1
host_info_show 1
host_players_show 2
exec banned_user.cfg
exec banned_ip.cfg
writeid
writeipa
EOT

echo "0 * * * * su - $USER -c '/home/$USER/csgoserver update'" >> /home/$USER/crontab_file
echo "*/5 * * * *  su - $USER -c '/home/$USER/csgoserver monitor'" >> /home/$USER/crontab_file

crontab "/home/$USER/crontab_file"

rm /home/$USER/crontab_file

su $USER -s ./csgoserver update
su $USER -s ./csgoserver start