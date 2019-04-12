#!/bin/bash
#termux bash script

pkg install figlet -y 

red='\e[1;31m'
green='e[1;32m'
blue='\e[1;34m'
purple='\e1;35m'

echo -e $red 
figlet Termux-Wifi
echo -e $blue by MrBlackx

pkg install git curl python python2 -y

termux-setup-storage
clear
pkg install figlet wget proot -y
wget https://raw.githubusercontent.com/Neo-Oli/termux-ubuntu/master/ubuntu.sh
bash ubuntu.sh
clear

echo -e $purple ================================================================
echo ""
eche $blue && figlet "Installing requirements...
echo ""
echo -e $purple ================================================================

chmod +rwx ubunut.sh
./ubuntu.sh

clear

echo -e $purple Successfully installed!

./start-ubuntu.sh

clear

apt-get update && apt-get upgrade -y

apt-get install git -y
apt-get install net-tools -y
apt-get install wireless_tools -y
apt-get install aircrack-ng -y
apt-get install xterm -y
apt-get install isc-dhcp-server -y
apt-get install reaver -y
apt-get install ettercap -y
apt-get install ettercap-text-only -y
apt-get install ettercap-graphical -y
apt-get install dsniff -y
apt-get install hostapd -y
apt-get install iptables -y
apt-get install bully -y
apt-get install ssltrip -y
apt-get install unzip -y
apt-get install expect -y
apt-get install expect-dev -y
apt-get install python -y
apt-get install python2 -y
apt-get install python3 -y
apt-get install lighttpd -y
apt-get install hashcat -y
apt-get install pixiewps -y
apt-get install curl -y
apt-get install pip -y
apt-get install iwconfig -y
apt-get install php-cgi -y
apt-get install dhcpd -y

# cloning fluxion
git clone https://github.com/wi-fi-analyzer/fluxion
cd fluxion && chmod +rwx *
./fluxion.sh

echo -e $red by MrBlackX

echo -e $green Successfully installed!



