#!/bin/bash
# More user friendly way of digging a Domain name

## Variables
DOMAIN_IP=`dig $1 A +short`

## Script
echo -e "\nThe domain $1 points to > $DOMAIN_IP" 
echo -e "\nThis belongs to the following:"

whois $DOMAIN_IP | grep -iE 'netname|address'

exit 0 


