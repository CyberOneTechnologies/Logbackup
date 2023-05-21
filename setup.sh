#!/bin/bash


#	░█████╗░██╗░░░██╗██████╗░███████╗██████╗░░█████╗░███╗░░██╗███████╗
#	██╔══██╗╚██╗░██╔╝██╔══██╗██╔════╝██╔══██╗██╔══██╗████╗░██║██╔════╝
#	██║░░╚═╝░╚████╔╝░██████╦╝█████╗░░██████╔╝██║░░██║██╔██╗██║█████╗░░
#	██║░░██╗░░╚██╔╝░░██╔══██╗██╔══╝░░██╔══██╗██║░░██║██║╚████║██╔══╝░░
#	╚█████╔╝░░░██║░░░██████╦╝███████╗██║░░██║╚█████╔╝██║░╚███║███████╗
#	░╚════╝░░░░╚═╝░░░╚═════╝░╚══════╝╚═╝░░╚═╝░╚════╝░╚═╝░░╚══╝╚══════╝



# Check if cifs-utils is installed
if ! dpkg -s cifs-utils >/dev/null 2>&1; then
  echo "Installing cifs-utils..."
  sudo apt-get update
  sudo apt-get install cifs-utils -y
else
  echo "cifs-utils is already installed."
fi

# Check if git is installed
if ! dpkg -s git >/dev/null 2>&1; then
  echo "Installing git..."
  sudo apt-get update
  sudo apt-get install git -y
else
  echo "git is already installed."
fi

# Clone the repository
if [ ! -d "Logbackup" ]; then
  echo "Cloning Logbackup repository..."
  git clone https://github.com/CyberOneTechnologies/Logbackup.git
else
  echo "Logbackup repository is already cloned."
fi

# Copy the logbackup.sh script to /usr/local/sbin
echo "Moving logbackup.sh to /usr/local/sbin..."
sudo cp Logbackup/logbackup.sh /usr/local/sbin/logbackup.sh
sudo chmod +x /usr/local/sbin/logbackup.sh

# Add logbackup.sh to crontab if it's not already scheduled
if ! crontab -l | grep -q "logbackup.sh"; then
  echo "Adding logbackup.sh to crontab..."
  (crontab -l 2>/dev/null; echo "0 23 * * * /usr/local/sbin/logbackup.sh") | crontab -
fi

echo "Setup completed."

# Run logbackup.sh
/usr/local/sbin/logbackup.sh
