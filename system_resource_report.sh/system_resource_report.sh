#!/bin/bash
# system_resource_report.sh
# Simple system resource report generating tool


# Global variables come here



# Script - start
echo -e "\n-- System Resource Report --"
echo "Hostname: `hostname`"
echo -e "Public IP: `curl icanhazip.com -s`\n"

echo -e "==========================\n"
echo "-- Hard Disk Space --"
echo "Free Space"
echo -e "`df -h | grep -vE 'tmpfs|boot'`\n"
echo "Inodes"
echo -e "`df -Ti | grep -vE 'tmpfs|boot'`\n"

echo -e "==========================\n"
echo "-- RAM and Swap space --"
echo -e "`free -m`\n"

echo -e "==========================\n"
echo "-- CPU --"
echo -e "`lscpu | grep -E '^Thread|^Core|^Socket|^CPU\('lscpu | grep -E '^Thread|^Core|^Socket|^CPU\('`\n"

echo -e "==========================\n"
echo -e "-- Packages --\n"
echo -e "Last three updates\n"
yum history | head -n 6 | tail -n 5
echo -e ""
echo -e "Available packages for upgrade: `yum check-update -q | wc -l`\n"
echo "Current Kernel: `uname -r`"
echo "Latest Kernel:" 
yum check-update -q | grep -E 'kernel\.' | awk -F " " '{ print $2 }' 

echo -e "==========================\n"
if [ -e /usr/bin/sar ]; then
    echo -e "-- Today's server load --\n"
    echo "`sar -q`"
else
    echo "No SAR utility available. Is this intentional?"
fi

echo -e "==========================\n"
echo -e "-- Disk Performance --\n"
dd if=/dev/zero of=/test.test bs=1M count=1024 conv=fdatasync

echo -e "==========================\n"
#echo -e "-- Processes running --\n"
#processes come here


# Prompt the user whether it's ok to remove the script or not and clearing history
# -- Uncomment below for self erase to work --

#history -r

echo -e "\n##########################################"
#echo -e "The $0 script has finished running. Self erasing now... is this ok? y/n"

#read SELFERASE

#if [ $SELFERASE = y ]
#  then
#    rm -f $0
#    echo -e "\nFile: $0 removed!\n"
#  else
#    echo -e "\nThe $0 script has not been removed! Please don't leave me behind unless required later!\n"
#fi


# Script - end

exit 0



