#!/bin/bash


#	░█████╗░██╗░░░██╗██████╗░███████╗██████╗░░█████╗░███╗░░██╗███████╗
#	██╔══██╗╚██╗░██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗░██║██╔════╝
#	██║░░╚═╝░╚████╔╝░██████╦╝█████╗░░██████╔╝██║░░██║██╔██╗██║█████╗░░
#	██║░░██╗░░╚██╔╝░░██╔══██╗██╔══╝░░██╔══██╗██║░░██║██║╚████║██╔══╝░░
#	╚█████╔╝░░░██║░░░██████╦╝███████╗██║░░██║╚█████╔╝██║░╚███║███████╗
#	░╚════╝░░░░╚═╝░░░╚═════╝░╚══════╝╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝╚══════╝



# Set color variables for better readability
green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
reverse=$(tput rev)
bold=$(tput bold)
reset=$(tput sgr0)

# Ask for the network drive
echo "${blue}What is the network share drive? (i.e. //192.168.1.10/logs):${reset}"
read network_drive

# Ask for the local folder name
echo "${blue}What is the name of the local folder to use:${reset}"
read local_folder

# Creating the local folder under /mnt
echo "Creating local folder..."
sudo mkdir -p /mnt/${local_folder}

# Mount the network drive to the local folder
echo "Mounting the network drive..."
sudo mount -t cifs ${network_drive} /mnt/${local_folder}

if [ $? -ne 0 ]; then
  echo "${red}Failed to mount the network drive. Please check your settings and try again.${reset}"
  exit 1
fi

# Zip the log files and move them to the network drive
echo "Creating and moving the log backup..."
server_name=$(hostname)
date_time=$(date '+%Y-%m-%d_%H-%M-%S')
sudo tar -czf /var/log/${server_name}_${date_time}.tar.gz /var/log
sudo mv /var/log/${server_name}_${date_time}.tar.gz /mnt/${local_folder}

# Delete old backups (> 180 days)
echo "Deleting old backups..."
sudo find /mnt/${local_folder} -name "*.tar.gz" -type f -mtime +180 -delete

# Notify user of successful backup
echo "${green}Backup process completed.${reset}"
