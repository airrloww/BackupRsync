#!/bin/bash

# getting source and target directories from user input and save into variables
read -p "source directory (e.g. /path/to/backup_dir): " source
read -p "target directory (e.g. local: /path/to/backup_dir or remote: user@hostname:/path/to/backup_dir): " target

# getting the current timestamp
timestamp=$(date +%Y-%m-%d_%H-%M)

# split the target into host and destination
IFS=':'
read -a spliter <<< "$target"

# create the destination directory with the timestamp
if [[ $target == *:* ]]; then
    ssh ${spliter[0]} "mkdir -p ${spliter[1]}/$timestamp"
else
    mkdir -p $target/$timestamp
fi

# find the most recent backup directory
if [[ $target == *:* ]]; then
    latest_backup=$(ssh ${spliter[0]} "ls -td1 ${spliter[1]}/*/ | head -1")
else
    latest_backup=$(ls -td1 $target/*/ | head -1)
fi

# create an incremental backup
if [[ $target == *:* ]]; then
    rsync -a --link-dest="$latest_backup" $source/ ${spliter[0]}:${spliter[1]}/$timestamp/
else
    rsync -a --link-dest="$latest_backup" $source/ $target/$timestamp/
fi

# create a symlink to the target dir with the newest backup
if [[ $target == *:* ]]; then
   ssh ${spliter[0]} "ln -sfn ${spliter[1]}/$timestamp ${spliter[1]}/current"
else
   ln -sfn $target/$timestamp $target/current
fi
