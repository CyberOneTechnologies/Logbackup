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

echo "${green}What is the network share drive? (i.e. //192.168.1.10/logs):${reset}"
read network_drive

echo "${yellow}What is the name of the local folder to use:${reset}"
read local_folder
local_folder=${local_folder:-BackupLogs}

# Create the local_folder if it doesn't exist
mkdir -p $local_folder

# Get server name
server_name=$(hostname)

# Define time stamps
timestamp=$(date +"%Y%m%d%H%M")
archive_2months=$(date -d"-2 month" +"%Y%m%d")
archive_6months=$(date -d"-6 month" +"%Y%m%d")

# Set paths
log_path="/var/log"
backup_path="$local_folder/$server_name-$timestamp.zip"
network_path="$network_drive/$server_name-$timestamp.zip"

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
find $network_drive -name "*.zip" -type f -printf "%f\n" | while read file; do
    file_date=$(echo $file | cut -d'-' -f2 | cut -d'.' -f1)
    if (( $file_date < $archive_6months )); then
        rm -f $network_drive/$file
    fi
done

echo "${green}Backup process completed.${reset}"

# Move the script to /usr/local/sbin and set up the cron job
echo "${blue}Setting up daily job...${reset}"
script_path=$(realpath $0)
sudo mv $script_path /usr/local/sbin/logbackup.sh
(sudo crontab -l 2>/dev/null; echo "0 23 * * * /usr/local/sbin/logbackup.sh") | sudo crontab -
echo "${green}Setup completed. The script will now run every day at 2300.${reset}"


