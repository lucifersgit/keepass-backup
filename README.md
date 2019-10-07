General overview

database-backup-and-archive.sh is the combined script of the associated components database-backup.sh & database-archive.sh

Database backup creates a backup when the MD5SUM hashes of the previous and current DB do not match

Runnig the archive script, if there is a DB to backup, the archive script will create the appropriate directory, and move the file as required

Usage:

