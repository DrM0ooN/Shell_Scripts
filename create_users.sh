#!/bin/bash

# Usage: ./create_users.sh 2025_spring.csv

INPUT_FILE=$1
SEMESTER=$(basename "$INPUT_FILE" .csv)
OUTPUT_FILE="${SEMESTER}_users.csv"
GROUP="students"

# Creating group
sudo groupadd $GROUP 2>/dev/null

# Output CSV header
echo "student_id,username" > "$OUTPUT_FILE"

while IFS=, read -r student_id last_name first_name
do
    if [[ "$student_id" == "student_id" ]]; then
        continue
    fi

    username="${first_name:0:1}${last_name}${student_id}"
    username=$(echo "$username" | tr '[:upper:]' '[:lower:]')

    sudo useradd -m -s /bin/bash -g $GROUP "$username"
    echo "${username}:ChangeMe123" | sudo chpasswd
    sudo chage -d 0 "$username"  # forcing password change

    sudo mkdir -p /home/"$username"/{documents,code}
    sudo cp POLICY.md /home/"$username"/POLICY.md
    sudo chown -R "$username":"$GROUP" /home/"$username"

    echo "$student_id,$username" >> "$OUTPUT_FILE"
    echo "Created user: $username"

done < "$INPUT_FILE"
