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



# Color setup
green=`tput setaf 2`
blue=`tput setaf 4`
red=`tput setaf 1`
bold=`tput bold`
reset=`tput sgr0`

# Check if the user is root
if [ "$(id -u)" != "0" ]; then
    echo "${bold}${red}This script must be run as root. Use sudo su to switch to root user.${reset}"
    exit 1
fi

# Check if cifs-utils is installed
if ! command -v mount.cifs > /dev/null; then
    echo "${blue}Installing cifs-utils...${reset}"
    sudo apt-get update
    sudo apt-get install cifs-utils -y
else
    echo "cifs-utils is already installed."
fi

# Prompt for local folder name
echo "${green}What is the name of the local folder to use as a mount folder?:${reset}"
read local_folder
local_folder=${local_folder:-BackupLogs}

# Create the local_folder if it doesn't exist
echo "${blue}Creating a mount point for the drive...${reset}"
mkdir -p /mnt/$local_folder

# Prompt for the network share drive
echo "${green}What is the network share drive? (i.e. //192.168.1.10/logs):${reset}"
read network_share_drive

# Mount the network share drive
echo "${blue}Mounting the network drive...${reset}"
sudo mount -t cifs $network_share_drive /mnt/$local_folder

# Update the logbackup.sh script to replace "MNT_DRIVE" with $local_folder
echo "${blue}Updating the logbackup.sh script...${reset}"
sed -i "s|MNT_DRIVE|${local_folder}|g" logbackup.sh

# Move the logbackup.sh script to /usr/local/sbin
echo "${blue}Moving logbackup.sh to /usr/local/sbin...${reset}"
sudo mv logbackup.sh /usr/local/sbin/logbackup.sh

# Make the script executable
echo "${blue}Making the script executable...${reset}"
sudo chmod +x /usr/local/sbin/logbackup.sh

# Add logbackup.sh to the root user's crontab to run daily at 3 AM
echo "${blue}Adding logbackup.sh to crontab...${reset}"
echo "0 3 * * * /usr/local/sbin/logbackup.sh" | crontab -

echo "${green}Setup completed.${reset}"

