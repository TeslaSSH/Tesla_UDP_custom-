#!/bin/bash
#=== setup ===
cd 
rm -rf /root/udp
mkdir -p /root/udp
rm -rf /etc/UDPCustom
mkdir -p /etc/UDPCustom
sudo touch /etc/UDPCustom/udp-custom
udp_dir='/etc/UDPCustom'
udp_file='/etc/UDPCustom/udp-custom'
source <(curl -sSL 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/module')
#sudo apt update -y
#sudo apt upgrade -y
clear
print_center -ama "UPDATING THE RESOURCES"
msg -bar3
sleep 2
sudo apt install -y wget &>/dev/null
print_center "wget========✅"
sleep 2
sudo apt install -y curl &>/dev/null
print_center "curl========✅"
sleep 2
sudo apt install -y dos2unix &>/dev/null
print_center "udpBoost========✅"
sleep 2
sudo apt install -y neofetch &>/dev/null
print_center "Tesla Dependencies========✅"

sleep 3
#sudo apt install lolcat -y
# [Add a custom server banner to Welcome]
wget https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/mana.sh -O ~/udp/mana.sh &>/dev/null
chmod u+x ~/udp/mana.sh 
echo "sudo bash ~/udp/mana.sh" >> ~/.bashrc
source ~/.bashrc

source <(curl -sSL 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/module')
time_reboot() {
  print_center -ama "${a92:-System/Server Reboot In} $1 ${a93:-Seconds}"
  REBOOT_TIMEOUT="$1"

  while [ $REBOOT_TIMEOUT -gt 0 ]; do
    print_center -ne "-$REBOOT_TIMEOUT-\r"
    sleep 1
    : $((REBOOT_TIMEOUT--))
  done
  rm -f install.sh
  sleep 1
  echo -e "\033[01;31m\033[1;33m More Updates, Follow Us On \033[1;31m(\033[1;36mTelegram\033[1;31m): \033[1;37mUDP CUSTOM\033[0m"
  sleep 2
  reboot
}

# Path to the panama file
wget https://raw.githubusercontent.com/TeslaSSH/olwath/main/olwa.txt -O olwa.txt &>/dev/null
panama="olwa.txt"
# Check Ubuntu version
  print_center -ama "♻️CHECKING YOUR OPERATING SYSTEM"
  sleep 1
  msg -bar3
  sleep 3
if [ "$(lsb_release -rs)" = "8*|9*|10*|11*|16.04*|18.04*" ]; then
  print_center -ama -e "\e[1m\e[31m=====================================================\e[0m"
  print_center -ama -e "\e[1m\e[33m${a94:-this script is not compatible with your operating system}\e[0m"
  print_center -ama -e "\e[1m\e[33m ${a95:-Use Ubuntu 20 or higher}\e[0m"
  print_center -ama -e "\e[1m\e[31m=====================================================\e[0m"
  rm /home/ubuntu/install.sh
  exit 1
else
  echo ""
  print_center -ama "Your System is compatible with the Script✅"
  sleep 4
  print_center -ama " ⇢ INSTALLATION WILL NOW CONTINUE... <"
  sleep 3
  clear
fi
time_count() {
  print_center -ama "${a92:-Verification in progress}"
  echo ""
  sleep 2
  print_center -ama "Calculating the Key Hash...∜‱"
  sleep 1
  echo ""
  print_center -ama "${a920:-Please wait in} $1 ${a93:-Seconds}"
  echo ""
  TIME_COUNT="$1"
  while [ $TIME_COUNT -gt 0 ]; do
    print_center -ne "***-$TIME_COUNT-***\r"
    sleep 1
    : $((TIME_COUNT--))
  done
}

# Fetch Verif Console
is_panama_vald() {
    local answer="$1"
    grep -Fxq "$answer" "$panama"
}

	# Check if user has Valid KEY and then start installing if key is vaild
echo ""
print_center -nama "Verification Key is Required."
echo ""
print_center -ama "Purchase it from Telegram: Tesla SSH "
msg -bar3
sleep 3
echo ""
print_center -nama "What is your Verification Key?"
echo ""
read -p "ENTER KEY : " kufulu
msg -bar3
sleep 3
time_count 4
# Check if the answer is valid
if ! is_panama_vald "$kufulu"; then
  echo "Invalid Key detected ☹. Terminating the script."
  sleep 2
  print_center -ama "Let's meet again when you purchase key"
  # Search and remove raw files
  find / -type f -name "olwa.txt" -o -name "install.sh" 2>/dev/null | while read -r file;
  do
    rm -f "$file"
  done
  sleep 4
  exit 1
else
  echo "Confirmed ✅"
  sleep 1
  print_center -verd "╭════════════════════════════╮"
  print_center -verd "├⇝Verification Successful⇴ "
  print_center -verd "├⇝Tesla Says⇴ Thank you! "
  print_center -verd "╰════════════════════════════╯"
  echo "🔥INSTALLATION IN PROGRESS🔥"
  sleep 3

    # [change timezone to UTC +3]
  echo ""
  echo " ⇢ Changing City to Kampala"
  echo " ⇢ for Africa/Kampala [UG] GMT +03:00"
  ln -fs /usr/share/zoneinfo/Africa/Nairobi /etc/localtime &>/dev/null
  echo -e "Time Zone Now: ⇝ Kampala +03 GMT"
  sleep 3

  # [+clean up+]
  rm -rf $udp_file &>/dev/null
  rm -rf /etc/UDPCustom/udp-custom &>/dev/null
  # rm -rf /usr/bin/udp-request &>/dev/null
  rm -rf /etc/limiter.sh &>/dev/null
  rm -rf /etc/UDPCustom/limiter.sh &>/dev/null
  rm -rf /etc/UDPCustom/module &>/dev/null
  rm -rf /usr/bin/udp &>/dev/null
  rm -rf /etc/UDPCustom/udpgw.service &>/dev/null
  rm -rf /etc/udpgw.service &>/dev/null
  systemctl stop udpgw &>/dev/null
  systemctl stop udp-custom &>/dev/null
  # systemctl stop udp-request &>/dev/null

  # .........................................................................................

# [+get files ⇣⇣⇣+]
  print_center -ama "${a103:-setting up, please wait...}"
  echo "###################################################"
  echo "# Tesla SSH is busy installing everything for you.#"
  echo "# Leave Everything to Us...                       #"
  echo "###################################################"
  echo ""

print_progress() {
    local percentage=$1
    local progress=$((percentage / 2))  # Scale down to fit within 50 characters

    printf "[%-50s] %d%%\r" $(printf "%-${progress}s" "#" | tr ' ' '#') "$percentage"
}

# Iterate from 0 to 100 in 5% increments and update the progress bar
for i in {0..100..5}; do
    print_progress "$i"
    sleep 0.001  # Adjust the sleep duration for the desired speed of progress
done
  sleep 6
  # [+get files ⇣⇣⇣+]
  source <(curl -sSL 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/module') &>/dev/null
  wget -O /etc/UDPCustom/module 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/module' &>/dev/null
  chmod +x /etc/UDPCustom/module

  wget "https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/bin/udp-custom-linux-amd64" -O /root/udp/udp-custom &>/dev/null
  # wget "https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/bin/udp-request-linux-amd64" -O /usr/bin/udp-request &>/dev/null
  chmod +x /root/udp/udp-custom
  # chmod +x /usr/bin/udp-request

  wget -O /etc/limiter.sh 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/limiter.sh' &>/dev/null
  cp /etc/limiter.sh /etc/UDPCustom
  chmod +x /etc/limiter.sh
  chmod +x /etc/UDPCustom
  
  # [+udpgw+]
  wget -O /etc/udpgw 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/udpgw' &>/dev/null
  mv /etc/udpgw /bin
  chmod +x /bin/udpgw

  # [+service+]
  wget -O /etc/udpgw.service 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/config/udpgw.service' &>/dev/null
  wget -O /etc/udp-custom.service 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/config/udp-custom.service' &>/dev/null
  
  mv /etc/udpgw.service /etc/systemd/system
  mv /etc/udp-custom.service /etc/systemd/system

  chmod 640 /etc/systemd/system/udpgw.service
  chmod 640 /etc/systemd/system/udp-custom.service
  
  systemctl daemon-reload &>/dev/null
  systemctl enable udpgw &>/dev/null
  systemctl start udpgw &>/dev/null
  systemctl enable udp-custom &>/dev/null
  systemctl start udp-custom &>/dev/null

  # [+config+]
  wget "https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/config/config.json" -O /root/udp/config.json &>/dev/null
  chmod +x /root/udp/config.json
  # [+menu+]
  wget -O /usr/bin/udp 'https://raw.githubusercontent.com/TeslaSSH/Tesla_UDP_custom-/main/module/udp' &>/dev/null
  chmod +x /usr/bin/udp
  ufw disable &>/dev/null
  sudo apt-get remove --purge ufw firewalld -y &>/dev/null
  apt remove netfilter-persistent -y &>/dev/null
  sleep 4
  clear
  print_center -ama "WE WISH YOU SUCCESS!"
  msg -bar3
  sleep 2
  clear
  echo ""
  echo ""
  title "${a102:-INSTALLATION SUCCESSFUL}"
  print_center -ama "${a103:-  To see menu, type: \nudp\n}"
  msg -bar

  #!/bin/bash

  # Search and remove raw files
  find / -type f -name "olwa.txt" -o -name "install.sh" 2>/dev/null | while read -r file;
  do
    rm -f "$file"
  done
  time_reboot 10
fi
