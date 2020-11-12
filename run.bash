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
rm -rf /var/log/lastlog
service sshd restart
cd /root&&git clone https://github.com/dylanaraps/neofetch.git&&cd neofetch&&make install&&cd ..&&neofetch&&echo -e 'print_info() {\n    info title\n    info underline\n    info "OS" distro\n    info "Host" model\n    info "Kernel" kernel\n    info "Uptime" uptime\n    info "Packages" packages\n    info "Resolution" resolution\n    info "DE" de\n    info "WM" wm\n    info "Terminal" term\n    info "CPU" cpu\n    info "GPU" gpu\n    info "Memory" memory\n    info "Disk" disk\n    info "Locale" locale\n    info underline\n}'>/root/.config/neofetch/config.conf&&neofetch
export HN="$1"&&echo -e "[network]\ngenerateHosts = false">/etc/wsl.conf&&echo -e "127.0.0.1       localhost\n127.0.1.1       $HN.localdomain     $HN\n10.0.0.10       host.docker.internal\n10.0.0.10       gateway.docker.internal\n127.0.0.1       kubernetes.docker.internal\n\n# The following lines are desirable for IPv6 capable hosts\n::1     ip6-localhost ip6-loopback\nfe00::0 ip6-localnet\nff00::0 ip6-mcastprefix\nff02::1 ip6-allnodes\nff02::2 ip6-allrouters">/etc/hosts&&cat /etc/hosts
echo -e 'net --quick\nif [ $EUID -eq 0 ] && [ "$HOME" != "/root" ]; then\n    export HOME="/root"\nfi\nhn="'$1'"\necho $hn>/etc/hostname\nhostname $hn\nexport "HOSTNAME=$hn"\nalias neofetch="neofetch --config /root/.config/neofetch/config.conf"\nsource ~/.bashrc'>/root/.profile
echo -e 'PS1="\e[0m\e[91;1m[  \e[94;1m\u@$HOSTNAME\e[91;1m  ] \e[92;1m| \e[93;1m\w \e[92;1m>>>\e[0;1m "\nneofetch'>/root/.bashrc
echo -e "# This file describes the network interfaces available on your system\n# and how to activate them. For more information, see interfaces(5).\n\nsource /etc/network/interfaces.d/*\n\n# The loopback network interface\nauto lo\niface lo inet loopback\n\n# The primary network interface\nauto eth0\niface eth0 inet dhcp\n\n# The LAN Interface\nauto eth1\niface eth1 inet dhcp\n\n# The SSH Interface\nauto eth2\niface eth2 inet static\n	address 69.4.20.$2\n	netmask 255.255.255.0\n\n# The REST API Interface\nauto eth3\niface eth3 inet static\n	address 4.20.69.$2\n	netmask 255.255.255.0\n\n# The FTP Interface\nauto eth4\niface eth4 inet static\n     address 6.6.6.1\n     netmask 255.255.255.0\n">/etc/network/interfaces
echo -e '#!/bin/bash\nif [[ $EUID -ne 0 ]];then\necho "Run Me As Root!"\nexit 1\nfi\nif [[ "$1" != "--quick" ]];then\nsystemctl restart networking\nfi\nfor i in {1..3..1};do\nip -6 addr flush eth$i\ndone\n'>/usr/bin/net&&chmod +x /usr/bin/net
echo -e '#!/bin/bash\n\n#DEFAULT IF NO ARG IS PASSED\ndefault=openbsd\n#SET THIS TO MAKE IT STAY SILENT (except for neofetch)\n#stfu="silent"\nif [[ $EUID -ne 0 ]];then\necho "Run me as root!"\nexit 1\nfi\necho -e '"'"'source /root/os\nPRETTY_NAME="$OS"\nNAME="$OS"\nID=$OS\n'"'"'>/etc/os-release\nif [[ "$#" == "0" ]] || [ "$#" == "1" ]; then\nsource /etc/os-release\norig=$ID\nfi\nfor arg in "$@";do\nif [[ "$arg" == "" ]] || [ "$arg" == " " ]; then\narg=$default\nfi\necho "export OS=$arg">/root/os&&neofetch\ndone\nif [[ "$#" == "0" ]]; then\necho "export OS=$default">/root/os&&neofetch\nfi\nif [[ "$orig" != "" ]]; then\nsource /etc/os-release\nif [[ "$ID" != "$orig" ]] && [ "$stfu" != "silent" ]; then\necho "Successfully Changed OS From $orig to $ID"\nelse\nif [[ "$stfu" != "silent" ]];then\necho "OS Was Unchanged"\nfi\nfi\nfi\n'>/usr/bin/setos&&chmod +x /usr/bin/setos
echo "Done!!!"
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
cd ..&&rm -rf ./do2
touch ~/.hushlogin
systemctl reboot||reboot||echo "Could not reboot."