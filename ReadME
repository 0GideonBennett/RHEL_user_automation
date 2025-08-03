 🛠️ UserManager – Linux User Automation Script

A Bash script that automates key user management tasks on RHEL-based systems, including:

- Creating new users with default passwords
- Assigning users to custom groups
- Granting users sudo privileges (wheel group)
- Logging all actions in timestamped log files

Tested successfully on the RHEL 10 (VirtualBox VM).

---

## 📂 Features

- ✅ Interactive CLI prompts
- ✅ Group existence checking + creation
- ✅ Logs all actions to `logs/` folder with timestamped session logs
- ✅ Safe input handling with whitespace trimming and existence checks

---

## 📥 Installation

1. Clone the repository:

git clone https://github.com/yourusername/UserManager.git
cd UserManager
Make the script executable:

chmod +x user_manager.sh
Important: Always run the script with sudo:


sudo ./user_manager.sh
🔒 Without sudo, commands like groupadd and usermod will fail with “Permission denied.”

⚙️ Usage
On script start, you'll be prompted to choose from:

1) Create new users and assign them a default password
2) Assign specific users to a specific group
3) Grant specific users sudo (wheel) privileges
Each option includes interactive prompts to collect usernames and group names.

🧪 Testing Guide
Feature	Test Step	How to Confirm
Create Users	Enter usernames + password	id username, su - username, ls /home/username
Assign Group	Enter existing + non-existing users and group name	id username, getent group groupname
Grant Sudo	Add users to wheel group	groups username, sudo whoami
Logging	Check log files in logs/ folder	cat logs/session_*.log

🧱 Script Breakdown
mkdir -p logs: ensures logs folder exists

tee -a logs/session_<timestamp>.log: logs to both terminal and file

usermod -aG wheel <user>: grants sudo privileges on RHEL

⚠️ Known Issues / Things to Watch For
🔐 You must run the script with sudo

Otherwise, user/group creation will fail with “Permission denied”

🧪 If testing multiple times, clean up users/groups manually with:

sudo userdel -r testuser
sudo groupdel testgroup
📜 License
MIT License
