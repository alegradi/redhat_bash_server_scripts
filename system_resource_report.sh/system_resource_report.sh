#!/bin/bash
# system_report.sh
# written by: A.L.

# Simple system report generating tool

# Global variables come here



# Script - start
echo ""
echo "-- System Rescource Report --"
echo "Hostname: `hostname`"
echo "Public IP: `curl icanhazip.com -s`"
echo ""
echo "=========================="
echo ""
echo "-- Hard Disk Space --"
echo "Free Space"
echo "`df -h | grep -vE 'tmpfs|boot'`"
echo ""
echo "Inodes"
echo "`df -Ti | grep -vE 'tmpfs|boot'`"
echo ""
echo "=========================="
echo ""
echo "-- RAM and Swap space --"
echo "`free -m`"
echo ""
echo "=========================="
echo ""
echo "-- CPU --"
echo "`lscpu | grep -E '^Thread|^Core|^Socket|^CPU\('lscpu | grep -E '^Thread|^Core|^Socket|^CPU\('`"
echo ""
echo "=========================="
echo ""
echo "-- Packages --"
echo ""
echo "Last three updates"
yum history | head -n 6 | tail -n 5
echo ""
echo "Available packages for upgrade: `yum check-update -q | wc -l`"
echo ""
echo "Current Kernel: `uname -r`"
echo "Latest Kernel:" 
yum check-update -q | grep -E 'kernel\.' | awk -F " " '{ print $2 }' 
echo "=========================="

# Script - end

exit 



