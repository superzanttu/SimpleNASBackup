#!/bin/bash
B_NAME="Simple NAS Backup"

# Settings
BACKUP_TARGET_MOUNTPOINT="/Volumes/NASbackup"
BACKUP_SOURCE="/Volumes/lightroom"



RSYNC_EXCLUDE_FILE="./backup-exclude.txt"
RSYNC_INCLUDE_FILE="./backup-include.txt"
RSYNC_OPTIONS="-avbK --itemize-changes --no-owner --no-group --copy-unsafe-links --stats --progress --delete-excluded --exclude-from $RSYNC_EXCLUDE_FILE --include-from $RSYNC_INCLUDE_FILE"

function PrintParameters {
# Print name
echo ""
echo "$B_NAME"
echo ""
# Print settings
echo "Settings"
echo "   Current day: $CDAY"
echo "   Source: $BACKUP_SOURCE"
echo "   Target mount point: $BACKUP_TARGET_MOUNTPOINT"
echo "   Target folder OK: $BACKUP_TARGET_FOLDER_OK"
echo "   Target folder FAIL: $BACKUP_TARGET_FOLDER_FAIL"
echo "   Target folder INCOMPLETE: $BACKUP_TARGET_FOLDER_INCOMPLETE"
echo "   Previous target folder: $PREVIOUS_BACKUP_TARGET_FOLDER"
echo "   Rsync options: $RSYNC_OPTIONS"
echo "   Rsync link dest: $RSYNC_LINK_DEST"
echo "   Exclude file: $RSYNC_EXCLUDE_FILE"
echo "---start---"
cat "$RSYNC_EXCLUDE_FILE"
echo "--end--"
echo "   Include file: $RSYNC_INCLUDE_FILE"
echo "---start---"
cat "$RSYNC_INCLUDE_FILE"
echo "--end--"

}


# Target folder name
CDAY=`date +%Y-%m-%d-%H%M%S`

BACKUP_TARGET_FOLDER_INCOMPLETE="$BACKUP_TARGET_MOUNTPOINT/BACKUP-$CDAY-INCOMPLETE"
BACKUP_TARGET_FOLDER_OK="$BACKUP_TARGET_MOUNTPOINT/BACKUP-$CDAY-OK"
BACKUP_TARGET_FOLDER_FAIL="$BACKUP_TARGET_MOUNTPOINT/BACKUP-$CDAY-FAIL"
PREVIOUS_BACKUP_TARGET_FOLDER=`find $BACKUP_TARGET_MOUNTPOINT  -maxdepth 1 -type d -name BACKUP*OK | sort | tail -n 1`
RSYNC_LINK_DEST="--link-dest $PREVIOUS_BACKUP_TARGET_FOLDER"

PrintParameters

# Check target mountpoint
if [ -d "$BACKUP_TARGET_MOUNTPOINT" ]
then	
	echo "OK: Backup target available"
else
	echo "ERROR: Backup target not available ($BACKUP_TARGET_MOUNTPOINT)."
	read -p "Press enter to quit"
	exit 1

fi

# Check backup target folder
if [ -d "$BACKUP_TARGET_FOLDER" ]
then
	echo "Creating backup target folder"
	mkdir "$BACKUP_TARGET_FOLDER_INCOMPLETE"
	if [ ! -d "$BACKUP_TARGET_FOLDER_INCOMPLETE" ]
	then
		echo "ERROR: Can't create backup target folder"
		read -p "Press enter to quit"
		exit 1
	fi
else
	echo "OK: Backup target folder exists"
fi

# Create backup
rsync $RSYNC_OPTIONS $RSYNC_EXCLUDE $RSYNC_LINK_DEST $BACKUP_SOURCE $BACKUP_TARGET_FOLDER_INCOMPLETE
if [ $? -ne 0 ]
then
	mv $BACKUP_TARGET_FOLDER_INCOMPLETE $BACKUP_TARGET_FOLDER_FAIL
	echo "ERROR: Backup failed"
	read -p "Press enter to quit"
	exit 1
fi

# Rename folder to OK
mv $BACKUP_TARGET_FOLDER_INCOMPLETE $BACKUP_TARGET_FOLDER_OK

PrintParameters
echo "DONE ($BACKUP_TARGET_FOLDER_OK)"




