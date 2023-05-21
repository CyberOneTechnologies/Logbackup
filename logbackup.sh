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
blue=$(tput setaf 4)
reverse=$(tput rev)
bold=$(tput bold)
reset=$(tput sgr0)

# Prompt for user input
echo "${blue}What is the network share drive? (i.e. //192.168.1.10/logs):${reset}"
read network_drive

echo "${blue}What is the username for the network share?${reset}"
read network_username

echo "${blue}What is the password for the network share?${reset}"
read -s network_password

echo "${blue}What is the name of the local folder to use:${reset}"
read local_folder
local_folder=${local_folder:-BackupLogs}

# Create the local folder if it doesn't exist
mkdir -p /var/log/$local_folder

# Mount the network drive
echo "Mounting the network drive..."
mount_point="/mnt/network_drive"
mkdir -p $mount_point
mount -t cifs $network_drive $mount_point -o username=$network_username,password=$network_password
if [ $? -ne 0 ]; then
  echo "${red}Failed to mount the network drive. Please check your settings and try again.${reset}"
  exit 1
fi

# Add the network drive to /etc/fstab if it's not already there
if ! grep -q "$network_drive" /etc/fstab; then
  echo "$network_drive $mount_point cifs username=$network_username,password=$network_password 0 0" >> /etc/fstab
  systemctl daemon-reload
fi

# Zip the logs and move them to the network drive
log_file_name=$(hostname)_$(date +'%Y%m%d_%H%M%S').zip
zip -r $log_file_name /var/log/* -x "/var/log/$local_folder/*"
mv $log_file_name /mnt/network_drive/$local_folder/

# Delete logs older than 6 months
find /mnt/network_drive/$local_folder/ -name "*.zip" -mtime +180 -exec rm {} \;

echo "${green}Backup completed successfully.${reset}"
