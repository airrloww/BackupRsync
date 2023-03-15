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

# create a directory and sync data 
if [[ $target == *:* ]]; then
    rsync -a $source/ ${spliter[0]}:${spliter[1]}/$timestamp/
else
    rsync -a $source/ $target/$timestamp/
fi

# create a symlink to the target dir with the newest backup
if [[ $target == *:* ]]; then
   ssh ${spliter[0]} "ln -sfn ${spliter[1]}/$timestamp ${spliter[1]}/current"
else
   ln -sfn $target/$timestamp $target/current
fi
