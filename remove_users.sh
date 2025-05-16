#!/bin/bash

# Usage: ./remove_users.sh 2025_spring_users.csv

USER_FILE=$1
SEMESTER=$(basename "$USER_FILE" _users.csv)
ARCHIVE_DIR="/home/admin/archives"
ARCHIVE_NAME="${ARCHIVE_DIR}/${SEMESTER}.tar"

mkdir -p "$ARCHIVE_DIR"

# Archive and delete
while IFS=, read -r student_id username
do
    if [[ "$username" == "username" ]]; then
        continue
    fi

    sudo tar --append --file="$ARCHIVE_NAME" /home/"$username"
    sudo userdel -r "$username"
    echo "Archived and removed user: $username"

done < "$USER_FILE"
