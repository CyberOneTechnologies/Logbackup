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

echo "${yellow}What is the network share drive? (i.e. //192.168.1.10/logs):${reset}"
read network_drive
echo "${yellow}What is the name of the local folder to use:${reset}"
read local_folder

# Create the mount point if it doesn't exist
if [ ! -d "/mnt/$local_folder" ]; then
    echo "${yellow}Creating mount point /mnt/$local_folder...${reset}"
    sudo mkdir /mnt/$local_folder
fi

# Mount the network drive
echo "${yellow}Mounting the network drive...${reset}"
mount_output=$(sudo mount -t cifs $network_drive /mnt/$local_folder -o username=guest,vers=1.0 2>&1)

if [ $? -eq 0 ]; then
    echo "${green}Network drive mounted successfully.${reset}"
else
    echo "${red}Failed to mount the network drive. Please check your settings and try again.${reset}"
    echo "Error details: $mount_output"
    exit 1
fi

# Add the mount to /etc/fstab if it's not already there
if ! grep -q "$network_drive /mnt/$local_folder" /etc/fstab; then
    echo "${yellow}Adding the mount to /etc/fstab...${reset}"
    echo "$network_drive /mnt/$local_folder cifs username=guest,vers=1.0 0 0" | sudo tee -a /etc/fstab > /dev/null
fi

# Check if the local_folder exists in the network drive, if not create it
if [ ! -d "/mnt/$local_folder/$local_folder" ]; then
    echo "${yellow}Creating $local_folder in the network drive...${reset}"
    sudo mkdir "/mnt/$local_folder/$local_folder"
fi

echo "${green}${bold}Setup completed.${reset}"
