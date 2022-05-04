#!/bin/bash
# Created by MrBlackX/TheMasterCH
# Modified by: 0n1coOn3
# Version 0.2
pkg install figlet -y
red=$(tput setaf 1)
blue=$(tput setaf 4)
white=$(tput setaf 7)
termux-setup-storage
apt install git curl python2 python3
clear

apt install proot-distro
proot-distro install ubuntu
clear

echo -e ${red} ================================================================
echo " "
echo -e ${blue} && echo -e "Installing requirements..."
echo " "
echo -e ${red} ================================================================
#proot-distro login ubuntu
clear
echo -e ${white} "Successfully installed!"
sleep 3
clear

apt-get update -y
apt-get upgrade -y
apt-get install git net-tools wireless-tools aircrack-ng  unzip -y

# cloning fluxion
git clone https://www.github.com/FluxionNetwork/fluxion.git
echo -e ${blue} "Installation completed"
echo -e ${red} "Made by : MrBlackX/TheMasterCH"
echo -e "Modified by : 0n1cOn3"
echo -e "Under development.Please be patient for full version"
