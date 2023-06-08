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




# Define color codes
red='\033[1;31m'
reset='\033[0m'

# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo -e "${red}This script must be run as root. Please switch to root user using 'sudo su'.${reset}"
    exit 1
fi

# Check if cifs-utils is installed
if ! dpkg -l | grep -q cifs-utils; then
    echo "Installing cifs-utils..."
    apt-get update && apt-get install -y cifs-utils
else
    echo "cifs-utils is already installed."
fi

# Check if git is installed
if ! dpkg -l | grep -q git; then
    echo "Installing git..."
    apt-get update && apt-get install -y git
else
    echo "git is already installed."
fi

# Clone the repository
echo "Cloning Logbackup repository..."
if [ ! -d "Logbackup" ]; then
    git clone https://github.com/CyberOneTechnologies/Logbackup.git
else
    echo "Logbackup repository already exists."
fi

# Prompt for local folder name
echo "What is the name of the local folder to use for the mount point?"
read local_folder
local_folder=${local_folder:-BackupLogs}

# Create the local_folder if it doesn't exist
echo "Creating a mount point for the drive..."
mkdir -p /mnt/$local_folder

# Substitute MNT_DRIVE with the local_folder name in logbackup.sh
sed -i "s|MNT_DRIVE|/mnt/$local_folder|g" Logbackup/logbackup.sh

# Copy the logbackup.sh script to /usr/local/sbin
echo "Moving logbackup.sh to /usr/local/sbin..."
cp Logbackup/logbackup.sh /usr/local/sbin/logbackup.sh
chmod +x /usr/local/sbin/logbackup.sh

# Add logbackup.sh to crontab to run every day at midnight
(crontab -l 2>/dev/null; echo "0 0 * * * /usr/local/sbin/logbackup.sh") | crontab -

echo "Setup completed."


# Add logbackup.sh to crontab if it's not already scheduled
echo "${blue}Adding Logging Backup process to Crontab to schedule process.:${reset}"
echo "0 23 * * * root /usr/local/sbin/logbackup.sh" >> /etc/crontab



echo "${green}Setup completed!!:${reset}"

# Run logbackup.sh
echo "${blue}Running the script the first time...:${reset}"
/usr/local/sbin/logbackup.sh
