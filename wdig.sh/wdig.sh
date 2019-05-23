#!/bin/bash
# More user friendly way of digging a Domain name with extended information
# Run it as an executable, alias it or place it in /bin/ 
# Usage: wdig.sh domain_name 

dig $1 ANY > /tmp/wdig_temp

## Variables
DOMAIN_IPV4=`grep -w A /tmp/wdig_temp | awk '{ print $5 }'`
DOMAIN_IPV6=`grep -w AAAA /tmp/wdig_temp | awk '{ print $5 }'`

#Left this in as reference
#whois=$(whois $DOMAIN_IPV4 | grep -iE 'netname|address')

## Script
# Check if the variable is not empty
if [ ! -z "$DOMAIN_IPV4" ]
then
    echo -e "\nThe domain $1 points to > $DOMAIN_IPV4 IPv4"
    echo -e "\nThis belongs to the following:"
    echo -e "`whois $DOMAIN_IPV4 | grep -iE 'netname|address' && sleep 1`"
else
    echo -e "\nThe domain $1 has no A record"
fi

#echo "\nThis should get printed also "

if [ ! -z "$DOMAIN_IPV6" ]
then
    echo -e "\nThe domain $1 points to > $DOMAIN_IPV6 IPv6"
    echo -e "\nThis belongs to the following:"
    echo -e "`whois $DOMAIN_IPV6 | grep -iE 'netname|address' && sleep 1`"
else
    echo -e "\nThe domain $1 has no AAAA record"
fi

exit 0

