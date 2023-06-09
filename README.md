# Log Backup Automation Scripts
This repository contains two bash scripts: **`logbackup.sh`** and **`setup.sh`**, designed to automate the process of creating and maintaining log backups.

## Getting Started

> **Please Note:** Running this as root is the only way for it to automatically update the crontab. If you run as a user with sudo then crontab won't update and the file will not be moved to your PATH list automatically. It is advised to run as root to avoid additional configurations.


# 1. Script Overview
### logbackup.sh
- This script compresses the **`/var/log directory`**, creates a backup, and moves it to a predefined network drive.
- It also removes backups that are older than 180 days from the network drive.

### setup.sh
- This script is responsible for the initial setup of the system.
- It installs required packages, sets up the network drive, and schedules the **`logbackup.sh`** script to run daily using crontab.


# 2. Usage
## 2.1 Cloning the repository
Firstly, clone the repository to your local system using the following command:

```
git clone https://github.com/CyberOneTechnologies/Logbackup.git
```

Navigate to the project directory:

```
cd Logbackup
```

Ensure that the script file is executable:

```
chmod +x setup.sh
```
## 2.2 Configuration
Before running the setup.sh script, the script will prompt you for the following inputs:

- The network share drive (i.e., **`//192.168.1.10/logs`**)
- The name of the local folder to use as a mount point.
These inputs will be used to configure your specific backup system. If the network drive or local folder does not exist, the script will attempt to create it.


## 2.3 Running the Scripts
To run the setup.sh script, navigate to the directory containing the scripts and use the following command:

```
sudo ./setup.sh
```

After running the **`setup.sh script`**, the logbackup.sh script will be scheduled to run daily. It will also be copied to **`/usr/local/sbin/logbackup.sh`**.

The **`logbackup.sh`** script can also be run manually by executing the following command:
```
/usr/local/sbin/logbackup.sh
```

This will immediately create a backup and move it to the network drive, as well as delete any backups older than 180 days.


# 3. Dependencies
The **`setup.sh`** script checks if **`cifs-utils`** and **`git`** are installed. If they are not, it will attempt to install these packages.

**`cifs-utils`** is required for mounting network file systems, while **`git`** is required to clone and update the repository.


# 4. Crontab Setup
The **`setup.sh`** script sets up a daily cron job to run the **`logbackup.sh`** script at 11 PM server time. The cron entry is added to the **`/etc/crontab file`**.


# 5. Error Handling
The scripts include basic error handling. For instance, if the network drive fails to mount during the setup, the setup.sh script will terminate and display an error message.

# 6. Output
The scripts output informational messages in color, indicating the progress of the operations being performed. Green text signifies successful operations, yellow text is for informational messages, and red text is for error messages.

Please make sure to check these messages to ensure the scripts have executed successfully.

# 7. Conclusion
These scripts provide a straightforward and automated way to handle log backups. They are particularly useful for Linux administrators looking for an efficient way to maintain backups of important system logs.


# Usage
The script will ask for the following inputs when run:

- **Network Share Drive:** The script will prompt you to enter the network share drive path (e.g., //192.168.1.10/logs).
- **Local Folder Name:** This is the local directory where the log backup will initially be stored. If you just press Enter without providing any name, "BackupLogs" will be used as a default.

Please note that the script only needs to be run once for setup. It will automatically run daily at 2300 as a cron job.

# Troubleshooting
- **Cron Jobs Not Running:** Please ensure that you have entered the correct path in the crontab file and the script is executable.
- **Permission Errors:** This script should be run as root, not as a sudo user. Running as a sudo user may lead to permission-related issues.
- **No Space Left on Device:** This might happen if your log directory is too large. Ensure that you have enough space on your device before running the script.
- **Network Drive Unreachable:** The script doesn't handle network issues. Please ensure that the network drive is reachable and the path you provided is correct.

# Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

# License
## MIT
