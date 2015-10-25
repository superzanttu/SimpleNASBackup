#!/bin/bash
B_NAME="Simple NAS Backup"

# Settings
BACKUP_TARGET="/Volumes/LightroomBackup"
BACKUP_SOURCE="/Volumes/lightroom"

rsync -rvnc --delete $BACKUP_SOURCE $BACKUP_TARGET

