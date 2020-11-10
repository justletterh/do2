#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo -e "This script must be run as root.\nExiting..." 
   exit 126
fi
[[ -d /root/.ssh ]]&&rm -r /root/.ssh
[[ -d /root/.ssh ]]||mkdir /root/.ssh
cp ./authorized_keys /root/.ssh/authorized_keys
[[ -f /etc/ssh/sshd_config ]]&&rm /etc/ssh/sshd_config
cp ./sshd_config /etc/ssh/sshd_config
echo done!
echo "Reboot? [Y/n]"
read -rsn1 input
if [[ "$input" = "y" ]]; then
    echo "Rebooting..."
    elif [[ "$input" = "n" ]]; then
    echo "Abort."
    exit 130
    else
    echo "Abort."
    exit 1
fi
cd ..&&rm -r ./do;systemctl reboot||reboot||echo "Could Not Reboot."