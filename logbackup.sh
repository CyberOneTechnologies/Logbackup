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

# Prompt for network drive
echo "${green}What is the network share drive? (i.e. //192.168.1.10/logs):${reset}"
read network_drive

# Prompt for local folder name
echo "${yellow}What is the name of the local folder to use:${reset}"
read local_folder
local_folder=${local_folder:-BackupLogs}

# Create the local_folder if it doesn't exist
mkdir -p $local_folder

# Mount the network drive if it isn't already
mount_point="/mnt/network_drive"
if ! grep -qs $mount_point /proc/mounts; then
    echo "${blue}Mounting the network drive...${reset}"
    sudo mkdir -p $mount_point
    echo "${network_drive}    ${mount_point}    cifs    guest,uid=1000,iocharset=utf8    0    0" | sudo tee -a /etc/fstab > /dev/null
    sudo mount -a
    if [ $? -eq 0 ]; then
        echo "${green}Network drive mounted successfully.${reset}"
    else
        echo "${red}Failed to mount the network drive. Please check your settings and try again.${reset}"
        exit 1
    fi
fi

# Check if the folder exists on the network drive, if not create it
if [ ! -d "$mount_point/$local_folder" ]; then
    echo "${blue}Creating the folder on the network drive...${reset}"
    mkdir -p "$mount_point/$local_folder"
fi

# Get server name
server_name=$(hostname)

# Define time stamps
timestamp=$(date +"%Y%m%d%H%M")
archive_2months=$(date -d"-2 month" +"%Y%m%d")
archive_6months=$(date -d"-6 month" +"%Y%m%d")

# Set paths
log_path="/var/log"
backup_path="$local_folder/$server_name-$timestamp.zip"
network_path="$mount_point/$local_folder/$server_name-$timestamp.zip"

# Remove existing archive files
find $local_folder -name "*.zip" -type f -delete

# Archive the log folder
echo "${blue}Creating backup of the log folder...${reset}"
zip -r $backup_path $log_path

# Move archive to the network drive
echo "${blue}Moving backup to the network drive...${reset}"
mv $backup_path $network_path

# Delete archive older than 6 months on the network drive
echo "${blue}Deleting archives older than 6 months...${reset}"
find $mount_point/$local_folder -name "*.zip" -type f -printf "%f\n" | while read file; do
    file_date=$(echo $file | cut -d'-' -f2 | cut -d'.' -f1)
    if (( $file_date < $archive_6months )); then
        rm -f $mount_point/$local_folder/$file
    fi
done

echo "${green}Log backup process completed.${reset}"
