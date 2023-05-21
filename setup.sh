#!/bin/bash


#	░█████╗░██╗░░░██╗██████╗░███████╗██████╗░░█████╗░███╗░░██╗███████╗
#	██╔══██╗╚██╗░██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗░██║██╔════╝
#	██║░░╚═╝░╚████╔╝░██████╦╝█████╗░░██████╔╝██║░░██║██╔██╗██║█████╗░░
#	██║░░██╗░░╚██╔╝░░██╔══██╗██╔══╝░░██╔══██╗██║░░██║██║╚████║██╔══╝░░
#	╚█████╔╝░░░██║░░░██████╦╝███████╗██║░░██║╚█████╔╝██║░╚███║███████╗
#	░╚════╝░░░░╚═╝░░░╚═════╝░╚══════╝╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝╚══════╝



# Set color variables
green=$(tput setaf 2)
yellow=$(tput setaf 3)
red=$(tput setaf 1)
bold=$(tput bold)
reset=$(tput sgr0)

# Check if cifs-utils is installed, if not install it
if ! dpkg -s cifs-utils >/dev/null 2>&1; then
    echo "${yellow}Installing cifs-utils...${reset}"
    sudo apt-get update
    sudo apt-get install cifs-utils -y
else
    echo "${green}cifs-utils is already installed.${reset}"
fi

# Check if git is installed, if not install it
if ! dpkg -s git >/dev/null 2>&1; then
    echo "${yellow}Installing git...${reset}"
    sudo apt-get install git -y
else
    echo "${green}git is already installed.${reset}"
fi

# Clone Logbackup repository
echo "${yellow}Cloning Logbackup repository...${reset}"
git clone https://github.com/CyberOneTechnologies/Logbackup.git

# Prompt user for the local folder name to use for the mount point
echo "${yellow}What is the name of the local folder to use for the mount point?${reset}"
read local_folder

# Change directory to the cloned Logbackup repository
cd Logbackup

# Replace 'network_drive' in logbackup.sh with the inputted local_folder
sed -i "s/network_drive/$local_folder/g" logbackup.sh

# Copy the logbackup.sh script to /usr/local/sbin
echo "Moving logbackup.sh to /usr/local/sbin..."
sudo cp logbackup.sh /usr/local/sbin/logbackup.sh
sudo chmod +x /usr/local/sbin/logbackup.sh

# Add logbackup.sh to crontab
echo "${yellow}Adding logbackup.sh to crontab...${reset}"
(crontab -l ; echo "0 23 * * * /usr/local/sbin/logbackup.sh") | crontab -

echo "${green}${bold}Setup completed.${reset}"
