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


# Check if cifs-utils is installed
echo "Checking if cifs-utils is installed...."
if ! dpkg -s cifs-utils >/dev/null 2>&1; then
  echo "Installing cifs-utils..."
  sudo apt-get update
  sudo apt-get install cifs-utils -y
else
  echo "cifs-utils is already installed."
fi

# Check if git is installed
echo "Checking if git is installed....."
if ! dpkg -s git >/dev/null 2>&1; then
  echo "Installing git..."
  sudo apt-get update
  sudo apt-get install git -y
else
  echo "git is already installed."
fi


# Prompt for network drive
echo "${green}What is the network share drive? (i.e. //192.168.1.10/logs):${reset}"
read network_drive

# Prompt for local folder name
echo "${green}What is the name of the local folder to use as a mount folder?:${reset}"
read local_folder
local_folder=${local_folder:-BackupLogs}

# Create the local_folder if it doesn't exist
echo "${blue}Creating a mount point for the drive...:${reset}"
mkdir -p /mnt/$local_folder

# Update the LogBackup.sh file with the local variable so it can run autonomously after setup.
echo "${yellow}Setting the mount point in logbackup.sh file :${reset}"
sed -i "s/MNT_DRIVE/$local_folder/g" ./logbackup.sh



# Mount the network drive if it isn't already
mount_point="/mnt/$local_folder"
if ! grep -qs $mount_point /proc/mounts; then
    echo "${blue}Mounting the network drive...:${reset}"
    sudo mkdir -p $mount_point
	sudo mount -t cifs ${network_drive} ${mount_point}
    echo "${network_drive}	${mount_point}	cifs	guest,uid=1000,iocharset=utf8	0	0" | sudo tee -a /etc/fstab > /dev/null
    sudo mount -a
    if [ $? -eq 0 ]; then
        echo "${green}Network drive mounted successfully.${reset}"
    else
        echo "${red}Failed to mount the network drive. Please check your settings and try again.${reset}"
        exit 1
    fi
fi


# Copy the logbackup.sh script to /usr/local/sbin
echo "Moving logbackup.sh to /usr/local/sbin..."
sudo cp logbackup.sh /usr/local/sbin/logbackup.sh
sudo chmod +x /usr/local/sbin/logbackup.sh

# Add logbackup.sh to crontab if it's not already scheduled
echo "Adding Logging Backup process to Crontab to schedule process"
echo "0 23 * * * /usr/local/sbin/logbackup.sh" >> /etc/crontab



echo "Setup completed."

# Run logbackup.sh
echo "Running the script the first
/usr/local/sbin/logbackup.sh
