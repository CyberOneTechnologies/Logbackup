#!/bin/bash

####################################################################################
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░LogBackup░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░Developed by Aarsyth░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
#░░░░░░░░░░░░GitHub Repository: https://github░com/CyberOneTechnologies/░░░░░░░░░░░#
#░░░░░░░░░░░░░░░░░For support, reach out on Discord: Aarsyth#0563░░░░░░░░░░░░░░░░░░#
####################################################################################
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
#░░░░█████╗░██╗░░░██╗██████╗░███████╗██████╗░░█████╗░███╗░░██╗███████╗░░░░░░░░░░░░░#
#░░░██╔══██╗╚██╗░██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗░██║██╔════╝░░░░░░░░░░░░░#
#░░░██║░░╚═╝░╚████╔╝░██████╦╝█████╗░░██████╔╝██║░░██║██╔██╗██║█████╗░░░░░░░░░░░░░░░#
#░░░██║░░██╗░░╚██╔╝░░██╔══██╗██╔══╝░░██╔══██╗██║░░██║██║╚████║██╔══╝░░░░░░░░░░░░░░░#
#░░░╚█████╔╝░░░██║░░░██████╦╝███████╗██║░░██║╚█████╔╝██║░╚███║███████╗░░░░░░░░░░░░░#
#░░░░╚════╝░░░░╚═╝░░░╚═════╝░╚══════╝╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝╚══════╝░░░░░░░░░░░░░#
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
####################################################################################
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
####################################################################################
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░Description:░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
#----------------------------------------------------------------------------------#
#░This project includes a set of bash scripts (setup.sh and logbackup.sh) designed░#
#░to automate the process of setting up a system to backup logs from a given server#
#░and store them in a designated local directory. The scripts handle system░░░░░░░░#
#░preparation, network drive mounting, and scheduling daily backups.░░░░░░░░░░░░░░░#
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░Features:░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
#----------------------------------------------------------------------------------#
#░- Automated system setup: setup.sh handles the installation of required tools░░░░#
#░░(cifs-utils and git), clones the repository, moves logbackup.sh to░░░░░░░░░░░░░░#
#░░/usr/local/sbin, and adds it to the crontab for daily execution.░░░░░░░░░░░░░░░░#
#░- Flexible network drive mounting: logbackup.sh prompts users to input the░░░░░░░#
#░░ network share drive and the local folder name to use for the mount point. The░░#
#░░ script then mounts the network share to the specified local folder.░░░░░░░░░░░░#
#░- Scheduled backups: logbackup.sh is added to the crontab to run daily at 23:00,░#
#░░ automating the backup process.░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
#░- Error Handling: Both scripts include error handling to ensure that each step is#
#░░ executed successfully before proceeding to the next one.░░░░░░░░░░░░░░░░░░░░░░░#
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
#░Let's get started!░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
#░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░#
####################################################################################



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
