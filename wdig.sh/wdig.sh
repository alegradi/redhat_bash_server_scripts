#!/bin/bash
# More user friendly way of digging a Domain name with extended information
# Until I find a better way to incorporate IPv6 checks it will stay like this
# Run it as an executable, alias it or place it in /bin/ 
# Usage: wdig domain_name

dig $1 ANY > /tmp/wdig_temp

## Variables
DOMAIN_IPV4=`grep -w A /tmp/wdig_temp | awk '{ print $5 }'`
DOMAIN_IPV6=`grep -w AAAA /tmp/wdig_temp | awk '{ print $5 }'`

#whois=$(whois $DOMAIN_IPV4 | grep -iE 'netname|address')
#whois="test"

#echo -e "$DOMAIN_IPV4"
#echo -e "$DOMAIN_IPV6"

#exit 0

## Script
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

