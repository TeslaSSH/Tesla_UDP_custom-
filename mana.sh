#!/bin/bash
clear
echo -e " _____ _____ ____  _        _      ____ ____  _   _ "
echo -e "|_   _| ____/ ___|| |      / \    / ___/ ___|| | | |"
echo -e "  | | |  _| \___ \| |     / _ \   \___ \___ \| |_| |"
echo -e "  | | | |___ ___) | |___ / ___ \   ___) |__) |  _  |"
echo -e "  |_| |_____|____/|_____/_/   \_\ |____/____/|_| |_|"
echo ""
echo -e "\t\033[92mA product of   : Tesla Projects Kampala" 
echo -e "\t\e\033[94mScripted By : @Teslassh.\033[0m"
echo ""
DATE=$(date +"%d-%m-%y")
TIME=$(date +"%T")
source <(curl -sSL 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/module')
echo -e "\t\e[1;33mServer Name : $HOSTNAME"
echo -e "\t\e[1;33mServer Uptime Time : $(uptime -p)"
echo -e "\t\e[1;33mServer Date : $DATE"
echo -e "\t\e[1;33mServer Time : $TIME"
echo "" 
echo "YOU CAN TYPE: sudo udp or udp"
msg -bar3
echo -e ""
exit
