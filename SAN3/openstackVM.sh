#!/bin/bash
#only apply on openstack command client on ubuntu VM
#only run once
#The setup is specific for AIC env: san3
#Pre-requirement: Download san3 - ltmi-acrs-prod-openrc.sh under  /root/tenentaccess/san3/
#
function pause(){
   read -p "$*"
}

#update /etc/hosts file
echo "xxx.xxx.xxx.xxx prod.dcp.aic.att.com" >> /etc/hosts
echo "xxx.xxx.xxx.xxx san3.aic.att.com" >> /etc/hosts
echo "xxx.xxx.xxx.xxx auth.cci.att.com" >> /etc/hosts
echo "xxx.xxx.xxx.xxx image.int.san3.cci.att.com" >> /etc/hosts

#install nova and glance command
apt-get -y install python-novaclient
apt-get -y install python-glanceclient
apt-get update

#source san3 - ltmi-acrs-prod
. /root/tenentaccess/san3/ltmi-acrs-prod-openrc.sh

#test comand output
nova list
#pause 'Press [Enter] key to continue...'
sleep 5
glance image-list
