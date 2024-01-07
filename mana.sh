#!/bin/bash
print_blue() {
    echo -e "\e[1;34m$1\e[0m"
}
print_yellow() {
    echo -e "\e[1;33m$1\e[0m"
}
print_pink() {
    echo -e "\e[1;95m$1\e[0m"
}
print_viola() {
    echo -e "\e[1;35m$1\e[0m"
}
clear
print_pink " _____ _____ ____  _        _      ____ ____  _   _ "
print_pink "|_   _| ____/ ___|| |      / \    / ___/ ___|| | | |"
print_blue "  | | |  _| \___ \| |     / _ \   \___ \___ \| |_| |"
print_yellow "  | | | |___ ___) | |___ / ___ \   ___) |__) |  _  |"
print_yellow "  |_| |_____|____/|_____/_/   \_\ |____/____/|_| |_|" 
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
echo -e "\t\e[1;33mUDP Provider : NextCloud Tech"
echo -e "\t\e[1;33mServer IP : $ip"
echo -e "\t\e[1;33mServer Date : $DATE"
echo "" 
echo "TO SEE MENU, TYPE: sudo udp or udp"
msg -bar3 
echo -e ""
exit
