# Log Backup Automation Scripts
This repository contains two bash scripts: `**logbackup.sh**` and `**setup.sh**`, designed to automate the process of creating and maintaining log backups.

## Getting Started

> **Please Note:** Running this as root is the only way for it to automatically update the crontab. If you run as a user with sudo then crontab won't update and the file will not be moved to your PATH list automatically. It is advised to run as root to avoid additional configurations.


# 1. Script Overview
### logbackup.sh
- This script compresses the `/var/log directory`, creates a backup, and moves it to a predefined network drive.
- It also removes backups that are older than 180 days from the network drive.

### setup.sh
- This script is responsible for the initial setup of the system.
- It installs required packages, sets up the network drive, and schedules the `logbackup.sh` script to run daily using crontab.




Clone the repository:

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

Run the script. This will move the script to /usr/local/sbin and set up a daily cron job to run the script at 2300:

```
sudo ./setup.sh
```


## Usage
The script will ask for the following inputs when run:

- **Network Share Drive:** The script will prompt you to enter the network share drive path (e.g., //192.168.1.10/logs).
- **Local Folder Name:** This is the local directory where the log backup will initially be stored. If you just press Enter without providing any name, "BackupLogs" will be used as a default.

Please note that the script only needs to be run once for setup. It will automatically run daily at 2300 as a cron job.

# Troubleshooting
- **Cron Jobs Not Running:** Please ensure that you have entered the correct path in the crontab file and the script is executable.
- **Permission Errors:** This script should be run as root, not as a sudo user. Running as a sudo user may lead to permission-related issues.
- **No Space Left on Device:** This might happen if your log directory is too large. Ensure that you have enough space on your device before running the script.
- **Network Drive Unreachable:** The script doesn't handle network issues. Please ensure that the network drive is reachable and the path you provided is correct.

### Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

## License
### MIT
