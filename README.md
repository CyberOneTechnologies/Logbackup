# LogBackup
LogBackup is a bash script designed for automatic backup of log files on Ubuntu Linux servers. This script archives the /var/log directory, stores the archive in a local directory, then moves it to a network drive. The script also manages the backup archives by deleting any that are older than 6 months.

## Getting Started
### Prerequisites
You must have root access on your server to use this script.

### Installation
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
chmod +x logbackup.sh
```

Run the script. This will move the script to /usr/local/sbin and set up a daily cron job to run the script at 2300:

```
sudo ./logbackup.sh
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
