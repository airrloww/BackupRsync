#!/bin/bash

# getting source and target directories from user input and save into variables
read -p "source directory (e.g. /path/to/backup_dir): " source
read -p "target directory (e.g. local: /path/to/backup_dir or remote: user@hostname:/path/to/backup_dir): " target

# getting the current timestamp
timestamp=$(date +%Y-%m-%d_%H-%M)


# create a directory and sycn data 
rsync -a --rsync-path="mkdir -p $source && rsync" $source $target

# split the targent into host and destination
IFS=':'
read -a spliter <<< "$target"


#create a symlink to the target dir with the newest backup 
if [[ $target == *:* ]]; then
   ssh -p 22 ${spliter[0]} "ln -sfn ${spliter[1]}/$timestamp ${spliter[1]}/current"
else
   ln -sfn $target/$timestamp $target/current
fi

