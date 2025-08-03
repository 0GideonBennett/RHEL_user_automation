#!/bin/bash

# ========================================
# RHEL User Management Script (RHCSA-aligned)
# Author: Your Name
# Description: Automates user creation, group assignment, and sudo privilege management.
# ========================================

# === Logging Setup ===

mkdir -p logs
log_file="logs/session_$(date +%Y%m%d_%H%M%S).log"
exec > >(tee -a "$log_file") 2>&1

echo "----- SESSION START: $(date) -----"
echo "All actions will be logged to $log_file"
echo

# === Menu ===

echo "Choose which action you wish to perform:"
echo "1) Create new users and assign them a default password"
echo "2) Assign specific users to a specific group"
echo "3) Grant specific users sudo (wheel) privileges"
read -p "Enter option number (1/2/3): " choice
echo

# === MINI SCRIPT 1: Create Users ===

if [[ "$choice" == "1" ]]; then
    users1=()

    echo "Enter usernames one by one. Type 'done' when finished."
    while true; do 
        read -p "Username: " userlist1
        userlist1=$(echo "$userlist1" | xargs)  # Trim whitespace

        if [[ "$userlist1" == "done" ]]; then
            break  
        fi
        users1+=("$userlist1")
    done

    echo
    echo "Number of users entered: ${#users1[@]}"
    echo "Users: ${users1[*]}"
    read -s -p "Enter the password to assign to all users: " default_password
    echo
    read -p "Proceed with user creation? (y/n): " confirm
    [[ "$confirm" != "y" ]] && echo "Canceled." && exit 1

    for username in "${users1[@]}"; do
        if id "$username" &>/dev/null; then
            echo "User '$username' already exists. Skipping..."
        else
            useradd -m "$username"
            echo "$username:$default_password" | chpasswd 
            echo "User '$username' created and password set."
        fi
    done

# === MINI SCRIPT 2: Add Users to Group ===

elif [[ "$choice" == "2" ]]; then
    users2=()

    echo "Enter usernames to assign to a group. Type 'done' when finished."
    while true; do
        read -p "Username: " userlist2
        userlist2=$(echo "$userlist2" | xargs)

        if [[ "$userlist2" == "done" ]]; then
            break
        fi
        users2+=("$userlist2")
    done

    read -p "Enter the group to assign users to: " groupName
    groupName=$(echo "$groupName" | xargs)

    if ! getent group "$groupName" > /dev/null; then
        echo "Group '$groupName' not found. Creating..."
        groupadd "$groupName"
    fi

    for user in "${users2[@]}"; do
        if id "$user" &>/dev/null; then
            usermod -aG "$groupName" "$user"
            echo "User '$user' added to group '$groupName'."
        else
            echo "User '$user' does not exist. Skipping."
        fi
    done

# === MINI SCRIPT 3: Grant Sudo Privileges ===

elif [[ "$choice" == "3" ]]; then
    users3=()

    echo "Enter usernames to grant sudo (wheel) access. Type 'done' when finished."
    while true; do
        read -p "Username: " userlist3
        userlist3=$(echo "$userlist3" | xargs)

        if [[ "$userlist3" == "done" ]]; then
            break
        fi
        users3+=("$userlist3")
    done

    for user in "${users3[@]}"; do
        if id "$user" &>/dev/null; then
            usermod -aG wheel "$user"
            echo "User '$user' granted sudo (wheel group) access."
        else
            echo "User '$user' does not exist. Skipping."
        fi
    done

else
    echo "Invalid option. Exiting."
fi

echo
echo "----- SESSION END: $(date) -----"
