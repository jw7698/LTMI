#!/bin/bash
#######################################################################
## This script is to setup LTMI ACRS subnet                                                                           ##
## Version 1.1                                                                                                                                ##
## created by Jason Wang on April 30, 2015                                                                           ##
## Working tenant : SAN3 (ltmi-acrs-prod)                                                                                      ##
#######################################################################
#You cannot run source within script
#source   /root/tenentaccess/iad1/iad1-ltm-id-proc-dev

set -o nounset
set -o errexit

LTMIACRS_RT="ACRS-Router"
LTMIACRS_SUB1="ACRSNW"
LTMIACRS_SUB2="ACRS_IntNW"
SUB1_IP="10.10.0.0/24"
SUB2_IP="192.168.0.0/24"

#create a router which shared for this tenant  
neutron router-create $LTMIACRS_RT

#attach shared router to public network 
neutron router-gateway-set $LTMIACRS_RT public

#create subnet to your specific project 
neutron net-create $LTMIACRS_SUB1
neutron net-create $LTMIACRS_SUB2

#Define subnet IP range  
neutron subnet-create $LTMIACRS_SUB1  $SUB1_IP --name  $LTMIACRS_SUB1
neutron subnet-create $LTMIACRS_SUB2  $SUB2_IP --name  $LTMIACRS_SUB2

#extract subnet ID info 
LTMIACRS_SUB1_ID=$(neutron subnet-list | awk  '/'$LTMIACRS_SUB1'/{print $2}')
LTMIACRS_SUB2_ID=$(neutron subnet-list | awk  '/'$LTMIACRS_SUB2'/{print $2}')

#Hook shared router to subnet 
neutron  router-interface-add $LTMIACRS_RT  $LTMIACRS_SUB1_ID
neutron  router-interface-add $LTMIACRS_RT  $LTMIACRS_SUB2_ID 
