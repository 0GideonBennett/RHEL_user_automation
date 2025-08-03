#!/bin/bash

#Before a selection is made Log all actions taken during this session to a file  ( All acitons that have occurred within this session will be saved to a file called session.txt) 

echo "Choose which action you wish to do:"
echo "Create new users and assign them a default password mini-- script 1
"
echo "script 2 "
etc


#Create new users and assign them a default password mini script 1

#Array to hold user names

users1=()


# While loop to retrieve and store the usernames

while true; do 

	read -p "Enter all the names of your users, and type done when finished (i.e Spock Kirk Picard... done):" userlist1
	
	#Check is the admin has typed done to signify the has typed all the usernames, but also make sure that "done" itself doesn't get counted as a username via the break, and the fact that we dont add the username to the usernames array until the if statement/check is finished
 	if [[$userlist1 == "done"]]; then
		break  
	fi
	
	users1+=(userlist1) #Add the typed usernames into the empty usernames array 



# Display the number of usersnames  within the usernames array and then display all their names so the admin can verify.
	echo "Number of users recently entered: ${#users1[@]}"
	echo "${users1[@]}"

	

# Ask the admin for the password they want all the users to have

read -s -p "Enter the password:" default_password

# Create the users based on the usernames inside the array and set a password for them

	#USe a Forloop to go though all the usernames within the usernames array, check if a  user exsits with that user name already and if not make the user 
	
	for username in "$(usernames[@]}";do  # username becomes a loop vaibrale (basically a var used to label/ target each usernames within the array)
		if id $username &>/dev/null; then     # this is running th eid command to display user information ( using id ) and if it returns output or error it will redirect to the /dev/null fule whcj bassually discards evveryhting (&> and /dev/null)
			echo "User $username  already exist"
		else #so because the user dont not exist then we need to create them
			useradd -m "$username"
			echo "$username:$defualt_passwd" | chpasswd 
			echo "The $username has been created and assigned the password set previously"
		fi
	done



_____________

# Assign specifc users to a spefic group ( mini script 2)

users2=()
	
read -p "What are the name(s) of the user(s) you want to assing to a group (type done when you're finished):" userlist2

if[[$userlist == "done"]] then;
	break
fi

users2+=(userlist2)

read -p "What is the name of the group you want to assing the user(s) to:" groupName

for user in "$(users2[@]}";do  #add each user wiht the users arrayt to a group specified 
		
	usermod -aG $groupName $user
done

_____________

#Assign spefic users sudo privledges (mini script 3)

users3=()
	
read -p "What are the name(s) of the user(s) you want to assing sudo priviledges (type done when you're finished):" userlist3

if[[$userlist == "done"]] then;
	break
fi

users3+=(userlist3)

read -p "What is the name of the sudo command you want to assing the user(s) to:" groupName

for user in "$(users3[@]}";do  # for each user within the array give them sudo privlideges 		
	sudo command something something allow 
done





---
COmpleted script 

#!/bin/bash

# === Start of Script Logging Setup ===

log_file="session.txt"
exec > >(tee -a "$log_file") 2>&1  # Logs stdout and stderr to both console and file

echo "----- SESSION START: $(date) -----"
echo "All actions in this session will be logged to $log_file"
echo

# === Menu ===

echo "Choose which action you wish to perform:"
echo "1) Create new users and assign them a default password"
echo "2) Assign specific users to a specific group"
echo "3) Grant specific users sudo privileges"
read -p "Enter option number (1/2/3): " choice

# === MINI SCRIPT 1 ===
if [[ "$choice" == "1" ]]; then

    users1=()

    echo "Enter usernames one by one. Type 'done' when finished."
    while true; do 
        read -p "Username: " userlist1
        if [[ "$userlist1" == "done" ]]; then
            break  
        fi
        users1+=("$userlist1")
    done

    echo "Number of users entered: ${#users1[@]}"
    echo "Users: ${users1[@]}"

    read -s -p "Enter the password to assign to all users: " default_password
    echo

    for username in "${users1[@]}"; do
        if id "$username" &>/dev/null; then
            echo "User '$username' already exists. Skipping..."
        else
            useradd -m "$username"
            echo "$username:$default_password" | chpasswd 
            echo "User '$username' has been created and assigned the password."
        fi
    done

# === MINI SCRIPT 2 ===
elif [[ "$choice" == "2" ]]; then

    users2=()

    echo "Enter usernames to assign to a group. Type 'done' when finished."
    while true; do
        read -p "Username: " userlist2
        if [[ "$userlist2" == "done" ]]; then
            break
        fi
        users2+=("$userlist2")
    done

    read -p "Enter the name of the group to assign the users to: " groupName

    # Create group if it doesn't exist
    if ! getent group "$groupName" > /dev/null; then
        echo "Group '$groupName' does not exist. Creating it..."
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

# === MINI SCRIPT 3 ===
elif [[ "$choice" == "3" ]]; then

    users3=()

    echo "Enter usernames to grant sudo privileges. Type 'done' when finished."
    while true; do
        read -p "Username: " userlist3
        if [[ "$userlist3" == "done" ]]; then
            break
        fi
        users3+=("$userlist3")
    done

    for user in "${users3[@]}"; do
        if id "$user" &>/dev/null; then
            usermod -aG sudo "$user"
            echo "User '$user' has been granted sudo privileges."
        else
            echo "User '$user' does not exist. Skipping."
        fi
    done

else
    echo "Invalid option. Exiting."
fi

echo "----- SESSION END: $(date) -----"


