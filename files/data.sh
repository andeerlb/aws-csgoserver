#!/bin/bash

yum update -y
amazon-linux-extras install epel -y
yum install curl wget tar bzip2 gzip unzip python3 binutils bc jq tmux glibc.i686 libstdc++ libstdc++.i686 -y

wget -O /home/ec2-user/linuxgsm.sh https://linuxgsm.sh 
chmod +x /home/ec2-user/linuxgsm.sh

cd /home/ec2-user/

su ec2-user -s ./linuxgsm.sh csgoserver

su ec2-user -s ./csgoserver auto-install
echo gslt=\"13D2E94677FC1C3859AF60FAFBE17234\" >> /home/ec2-user/lgsm/config-lgsm/csgoserver/csgoserver.cfg

crontab -l > csgoserver_update
crontab -l > csgoserver_monitor

echo "0 * * * * su - ec2-user -c '/home/ec2-user/lgsm update'" > csgoserver_update
echo "*/5 * * * *  su - username -c '/home/username/gameserver monitor'" > csgoserver_monitor

crontab csgoserver_update
crontab csgoserver_monitor

rm csgoserver_updateecho
rm csgoserver_monitor

su ec2-user -s ./csgoserver update
su ec2-user -s ./csgoserver start