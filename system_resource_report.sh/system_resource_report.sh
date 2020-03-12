# ###
# system_resource_report.sh
# Simple system resource report generating tool for Centos/RHEL servers - ideal for AM tasks of system check
# 
# ###

# Possible "To Do" list:
# 1, Disk health check incorporated with hdsentinel?
# 2, Verify if we are running a VM or dedicated server
# 3, What relevant processes are running
# 4, Number of sites hosted on the server


### Please don't touch anything below this line if you want the script to function as intended ###

# Clean up bash history
unset HISTFILE

# Install 'at' so that a job can be set for self erasure
if [[ ! -f /bin/at && ! -f /usr/bin/at ]]; then
    yum install at -q -y > /dev/null 2?&1
    if [ $(echo $?) = 1 ]; then
        echo -e "Cannot install 'at' !"
        exit 1
    fi
fi

# Create at scheduled job to remove this script # 
# echo "/bin/rm -f ${0}" | `which at` now + 15 minutes &> /dev/null

## Function Declaration ##

#Get hostname, IP 
function get_basic_info(){
PUBLIC_IP=$(curl icanhazip.com -s)
printf "Hostname: $HOSTNAME\n"
printf "Primary external IP: $PUBLIC_IP\n"
}

#Get CPU information
function get_cpu_info(){
CPU=$(cat /proc/cpuinfo | grep -m 1 'model name' | cut -f2 -d : | awk '$1=$1')
CPU_NUM=$(lscpu | grep -m 1 '^Socket' | cut -f2 -d : | awk '$1=$1')
CPU_CORES=$(cat /proc/cpuinfo | grep -m 1 'cpu cores' | cut -f2 -d : | awk '$1=$1')
CPU_CLOCK=$(cat /proc/cpuinfo | grep -m 1 'cpu MHz' | cut -f2 -d : | awk '$1=$1') 
printf "CPU: $CPU @ $CPU_CLOCK Mhz\n"
printf "Physical CPU(s): $CPU_NUM\n"
printf "CPU Cores: $CPU_CORES\n"
}

# Get BIOS information
function get_bios_info() {
BIOS=$(dmidecode | grep -A 3 -E 'BIOS Information' | grep -i version | cut -f2 -d : | awk '$1=$1')
printf "BIOS version: $BIOS\n"
}

# Get RAM information
function get_mem_info(){
RAM=$(free -h | grep -i mem: | cut -f2 -d: | awk '$1=$1' | cut -f1 -d' ')
printf "RAM: $RAM\n"
} 

# Get CPU load from sar
function get_cpu_load(){
printf "Today's CPU load averages \ *5 Min \ *10 Min \ *15 Min\n"
sar -q
}

# Get disk information
function get_disk_info(){
printf "Disk usage (data):\n"
df -h | grep -vE 'tmpfs|boot'
printf "\nDisk usge (inodes):\n"
df -Ti | grep -vE 'tmpfs|boot'
}

# Get package and update information
function get_update_info(){
PKG_AVAILABLE=$(yum check-update -q | wc -l)
KERNEL_VERSION=$(uname -r)
UP_TIME=$(uptime -p | sed 's/up//g' | awk '$1=$1')
printf "Server uptime: $UP_TIME\n"
printf "Currently installed Kernel: $KERNEL_VERSION\n"
printf "Number of packages available for update: $PKG_AVAILABLE\n"
printf "\nLast three updates applied:\n"
yum history | head -n 6 | tail -n 5
}


## Script - start ##

echo -e ""
echo -e "System Resource Report"
echo -e "==========================\n"
echo -e "-- Basic Information --"

get_basic_info

echo -e "==========================\n"
echo -e "-- Hardware Information --"

get_bios_info
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
echo -e "-- Disk information --"

get_disk_info

echo -e "==========================\n"
echo -e "-- Package and update information --"

get_update_info

echo -e "==========================\n"

## Script - end ##

exit 0

