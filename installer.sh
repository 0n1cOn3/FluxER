#!/bin/bash
# Created by MrBlackX/TheMasterCH
# Modified by: 0n1coOn3
# Version 0.2

pkg install figlet -y 

red='\e[1;31m'
green='e[1;32m'
blue='\e[1;34m'
purple='\e1;35m'

echo -e $red "figlet Termux-Wifi"
echo -e $blue "by MrBlackx/TheMasterCH"
echo -e $purple "modified by 0n1cOn3"

termux-setup-storage
apt install git curl python2 python3
clear

apt install figlet wget proot tar curl -y
# new Repo needs to be used cause the owner seems to discontinue the project (Readonly)wget https://raw.githubusercontent.com/Neo-Oli/termux-ubuntu/master/ubuntu.sh
wget https://raw.githubusercontent.com/tuanpham-dev/termux-ubuntu/master/ubuntu.sh
chmod +x ubuntu.sh
bash ubuntu.sh
clear

echo -e $purple ================================================================
echo " "
echo -e $blue && figlet "Installing requirements...
echo " "
echo -e $purple ================================================================

chmod +rwx ubuntu.sh
./ubuntu.sh
clear
echo -e $purple "Successfully installed!"
sleep 3
./start-ubuntu.sh
clear

apt-get update
apt-get upgrade -y
apt-get install git net-tools wireless_tools aircrack-ng xterm isc-dhcp-server reaver ettercap ettercap-text-only ettercap-graphical dsniff hostapd iptables bully ssltrip unzip expect expect-dev lighttpd hashcat pixiewps curl pip pip3 iwconfig php-cgi -y
dhcpd -y

# cloning fluxion
git clone https://www.github.com/FluxionNetwork/fluxion.git
cd fluxion && chmod +rwx *
./fluxion.sh

echo -e $red "by MrBlackX/TheMasterCH"
echo -e $purple "modified by 0n1cOn3
echo -e $green "Successfully installed!"



