# Bash Backup Script
This script takes a backup of a source directory to a target directory. The backup is incremental, with each new backup living in a timestamped directory. The target can be either local or remote (via ssh).

## Usage

```ssh
chmod +x backup.sh
```

```ssh
./backup.sh
```
