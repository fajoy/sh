#!/usr/bin/env bash
# Generate /etc/motd for CSCC Linux workstations.
# Pass 'cscore' as the 1st argument for TA only hosts.

hostname=$(hostname)
cpu=$(grep -m1 'model name' /proc/cpuinfo | sed 's/.*:\s*//' | tr -s ' ') # sed to remove everything before the first word after the colon.
mem=$(($(awk '/MemTotal/ { print $2 }' /proc/meminfo) / 1024)) # This only reports memory available to userspace processes.
tmp=$(df -h /tmp | tail -n +2 | awk '{ print $3 "/" $2 }')
welcome='Welcome to CS Linux Serivce!'
if [[ $1 == 'cscore' ]]; then
    openfor='Open for TA only!'
    color='33'
else
    openfor='Open for all students and faculty'
    color='32'
fi

# We use % as seperator for the 2nd line so we don't have to escape slashes (/).
figlet "$hostname" | sed \
-e "s/.*/\x1b[1;${color}m&\x1b[m/g" \
-e "1s/$/  CPU: $cpu/" \
-e "2s%$%  MEM: $mem MiB  /tmp: $tmp%" \
-e "4s/$/  $welcome/" \
-e "5s/$/  $openfor/"
