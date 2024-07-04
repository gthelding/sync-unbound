#!/bin/bash
# Set the variables for remote host (source of config file), remote user, and  SSH key
SRC_HOST=source.hostname
USER=username
PRIVATE_KEY=/path/to/ssh.key
#Service to reconfig and restart
SVC_NAME=unbound.service
#Path to config file for service on remote host
SRC_CONFIG=/etc/unbound/unbound.conf
#Path to temporarily store local copy of remote config file
TEMP_FILE=/path/to/temp.conf
#Path to local config file for service
LOCAL_CONFIG=/etc/unbound/unbound.conf

# Copy the remote config file to temp on local using SFTP
sftp -i $PRIVATE_KEY $USER@$SRC_HOST:$SRC_CONFIG $TEMP_FILE

# Check if sftp command was successful
if [ $? -eq 0 ]; then
    echo "File retrieved successfully."

    # Compare the retrieved config file with the local current config file
    diff $LOCAL_CONFIG $TEMP_FILE > /dev/null 2>&1

    # If the files are different, then substitute the current local config with the updated remote config
    if [ $? -ne 0 ]; then
        mv $TEMP_FILE $LOCAL_CONFIG
        echo "Config updated."

        # Restart the service
        systemctl restart $SVC_NAME

        # Verify that restart was successful
        if [ $? -eq 0 ]; then
            echo "Service $SVC_NAME restarted successfully."
        else
            echo "Failed to restart $SVC_NAME."
        fi
    else
        echo "Configurations match. No changes required."
         # Remove the retrieved file
        rm $TEMP_FILE
        echo "Temp file removed."
        exit 0
    fi
else
    echo "Failed to retrieve file."
fi
