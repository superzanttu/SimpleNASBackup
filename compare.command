#!/bin/bash
B_NAME="Simple NAS Backup"

# Settings
BACKUP_SOURCE="/Volumes/lightroom/main/"
BACKUP_TARGET="/Volumes/LightroomBackup/BACKUP-2015-10-22-170553-OK/lightroom/main/"



# add c option to compare contents
rsync -avn  $BACKUP_SOURCE $BACKUP_TARGET

