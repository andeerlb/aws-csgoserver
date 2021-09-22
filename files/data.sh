#!/bin/bash

USER="ec2-user"

yum update -y
amazon-linux-extras install epel -y
yum install curl wget tar bzip2 gzip unzip python3 binutils bc jq tmux glibc.i686 libstdc++ libstdc++.i686 -y

wget -O /home/$USER/linuxgsm.sh https://linuxgsm.sh 
chmod +x /home/$USER/linuxgsm.sh

cd /home/$USER/

su $USER -s ./linuxgsm.sh csgoserver

su $USER -s ./csgoserver auto-install
echo gslt=\"13D2E94677FC1C3859AF60FAFBE17234\" >> /home/$USER/lgsm/config-lgsm/csgoserver/csgoserver.cfg

su $USER -s crontab -l > /home/$USER/csgoserver_update
su $USER -s crontab -l > /home/$USER/csgoserver_monitor

echo "0 * * * * su - $USER -c '/home/$USER/lgsm update'" > /home/$USER/csgoserver_update
echo "*/5 * * * *  su - $USER -c '/home/$USER/csgoserver monitor'" > /home/$USER/csgoserver_monitor

crontab /home/$USER/csgoserver_update
crontab /home/$USER/csgoserver_monitor

rm /home/$USER/csgoserver_updateecho
rm /home/$USER/csgoserver_monitor

su $USER -s ./csgoserver update
su $USER -s ./csgoserver start