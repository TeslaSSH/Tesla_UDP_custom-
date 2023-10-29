#!/bin/bash
clear
echo -e " _____ _____ ____  _        _      ____ ____  _   _ "
echo -e "|_   _| ____/ ___|| |      / \    / ___/ ___|| | | |"
echo -e "  | | |  _| \___ \| |     / _ \   \___ \___ \| |_| |"
echo -e "  | | | |___ ___) | |___ / ___ \   ___) |__) |  _  |"
echo -e "  |_| |_____|____/|_____/_/   \_\ |____/____/|_| |_|"
echo ""
region=$(wget -qO- ipinfo.io/region)
isp=$(wget -qO- ipinfo.io/org)
ip=$(wget -qO- ipinfo.io/ip)
source <(curl -sSL 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/module')
msg -bar
echo -e "\t\033[92mA product of  : Tesla Projects Kampala" 
echo -e "\t\e\033[94mScripted By : @Teslassh.\033[0m"
msg -bar0
echo ""
DATE=$(date +"%d-%m-%y")
TIME=$(date +"%T")
echo -e "\t\e[1;33mServer Location : $region"
echo -e "\t\e[1;33mServer Provider : $isp"
echo -e "\t\e[1;33mServer IP : $ip"
echo -e "\t\e[1;33mServer Date : $DATE"
echo "" 
echo "TO SEE MENU, TYPE: sudo udp or udp"
msg -bar3
echo -e ""
exit
