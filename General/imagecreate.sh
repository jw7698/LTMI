#!/bin/bash
# CHG  00000xxxxxxx - LTMI VM snapshot image creation 
# Script to create sql1/dpa1/iad1 LTMI VMs snapshot image 
# usage:
#      ./imagecreate.sh 
#

shutdown() {
#for i in sql1-acrs-splfwd sql1-acrs-traffic01 sql1-acrs-admin sql1-acrs-db01 sql1-acrs-lb sql1-acrs-nagios; do
#for i in dpa1-acrs-splfwd dpa1-acrs-traffic01 dpa1-acrs-admin dpa1-acrs-db01 dpa1-acrs-lb dpa1-acrs-nagios; do
for i in  iad1-acrs-traffic01 iad1-acrs-admin iad1-acrs-db01 iad1-acrs-lb; do
echo $i
    nova stop $i 
    if [ "$?" -ne 0 ]; then echo "nova stop failed"; read -p "Pause and check... Press any key to continue"; fi
    nova list | grep $i
done
return
}

snapshotimage() {
#for i in sql1-acrs-splfwd sql1-acrs-traffic01 sql1-acrs-admin sql1-acrs-db01 sql1-acrs-lb sql1-acrs-nagios; do
#for i in dpa1-acrs-splfwd dpa1-acrs-traffic01 dpa1-acrs-admin dpa1-acrs-db01 dpa1-acrs-lb dpa1-acrs-nagios; do
for i in  iad1-acrs-traffic01 iad1-acrs-admin iad1-acrs-db01 iad1-acrs-lb; do
echo $i
    #nova image-create --poll  $i  `date +%Y%m%d`-golden-snapshot-`echo $i` || {echo "nova image-create failed"; read -p "Pause and check... Press any key to continue"}
    nova image-create --poll  $i  `date +%Y%m%d`-golden-snapshot-`echo $i`
    if [ "$?" -ne 0 ] ; then echo "nova stop failed"; read -p "Pause and check... Press any key to continue"; fi
    nova image-list | grep $i
done
return
}

start() {
#for i in sql1-acrs-splfwd sql1-acrs-traffic01 sql1-acrs-admin sql1-acrs-db01 sql1-acrs-lb sql1-acrs-nagios; do
#for i in dpa1-acrs-splfwd dpa1-acrs-traffic01 dpa1-acrs-admin dpa1-acrs-db01 dpa1-acrs-lb dpa1-acrs-nagios; do
for i in  iad1-acrs-traffic01 iad1-acrs-admin iad1-acrs-db01 iad1-acrs-lb; do
echo $i
    #nova start $i || {echo "nova start failed"; read -p "Pause and check... Press any key to continue"}
    nova start $i
    if [ "$?" -ne 0 ]; then echo "nova stop failed"; read -p "Pause and check... Press any key to continue"; fi
    nova list | grep $i
    sleep 15
done
return
}

nova_check() {
nova list | grep acrs
return
}


#
# MAIN program
#

#source /root/tenentaccess/sql1/sql1-ltmi-acrs-prod
#source /root/tenentaccess/DPA1/dpa1-ltmi-acrs-prod
source /root/tenentaccess/iad1/iad1-ats-vpse

IFS='
'
MENU="
shutdown VM
snapshot image creation
start VM 
nova check 
Exit/Stop
"
PS3='Select task:'
select m1 in $MENU
do
case $REPLY in
1) shutdown;;
2) snapshotimage;;
3) start;;
4) nova_check;;
5) exit 0 ;;
esac
done
