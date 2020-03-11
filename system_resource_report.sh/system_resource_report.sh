# ###
# system_resource_report.sh
# Simple system resource report generating tool for Centos/RHEL servers - ideal for AM tasks of system check
# ###

# To Do list?:
# 1, Disk health check incorporated with hdsentinel?
# 2, Verify if we are running a VM or dedicated server
# 3, What relevant processes are running
# 4, Number of sites hosted on the server


### Please don't touch anything below this line if you want the script to function as intended ###

# Clean up bash history
unset HISTFILE


# Function Declaration

function get_basic_info(){
PUBLIC_IP=$(curl icanhazip.com -s)
printf "Hostname: $HOSTNAME\n"
printf "Primary external IP: $PUBLIC_IP\n"
}

function get_cpu_info(){
CPU=$(cat /proc/cpuinfo | grep -m 1 'model name' | cut -f2 -d : | awk '$1=$1')
CPU_NUM=$(lscpu | grep -m 1 '^Socket' | cut -f2 -d : | awk '$1=$1')
CPU_CORES=$(cat /proc/cpuinfo | grep -m 1 'cpu cores' | cut -f2 -d : | awk '$1=$1')
CPU_CLOCK=$(cat /proc/cpuinfo | grep -m 1 'cpu MHz' | cut -f2 -d : | awk '$1=$1') 
printf "CPU: $CPU @ $CPU_CLOCK Mhz\n"
printf "Physical CPU(s): $CPU_NUM\n"
printf "CPU Cores: $CPU_CORES\n"
}

function get_mem_info(){
RAM=$(free -h | grep -i mem: | cut -f2 -d: | awk '$1=$1' | cut -f1 -d' ')
printf "RAM: $RAM\n"
} 

function get_cpu_load(){
printf "Today's CPU load averages \ *5 Min \ *10 Min \ *15 Min\n"
sar -q
}


# Script - start

echo -e ""
echo -e "System Resource Report"
echo -e "==========================\n"
echo -e "-- Basic Information --"

get_basic_info

echo -e "==========================\n"
echo -e "-- Hardware Information --"

get_cpu_info
get_mem_info

echo -e "==========================\n"
echo -e "-- Server usage --"

if [ -e /usr/bin/sar ]; then
    get_cpu_load  
else
    echo "No SAR utility available. SAR can be installed with 'yum install sysstat' from base repo"
fi




echo -e "==========================\n"
echo "-- Hard Disk Space --"
echo "Free Space"
echo -e "`df -h | grep -vE 'tmpfs|boot'`\n"
echo "Inodes"
echo -e "`df -Ti | grep -vE 'tmpfs|boot'`\n"

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
dd if=/dev/zero of=/tmp/test.test bs=1M count=1024 conv=fdatasync
rm -f /tmp/test.test

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



