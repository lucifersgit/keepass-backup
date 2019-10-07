#!/bin/bash

### 	This is a script that will be called with crontab to perform backups of the keepass Database, only if the MD5 hashes are different 		###
KEEPASSHOME=$HOME/keepass-database/

cd $KEEPASSHOME

###	 Backup files will be created with the format "Database-YYYYMMDD-hh:mm:ss" 									###
### 	 e.g - Database-20190821-090001.kdbx 				      										###

CURRENTDB="Database.kdbx"
COMPAREDB="$(find database-backups -type f  | grep -v .log | sort | tail -n 1)"

### This will return the MD5 hash of the specified files												###

CURRENTDBMD5=$(md5sum $CURRENTDB | awk '{print $1}')
COMPAREDBMD5=$(md5sum $COMPAREDB | awk '{print $1}')

### If the hash of CURRENTDB == COMPAREDB, then do nothing. Else, (if the hashes don't match), then create						###
### a backup																		###

if [ "$CURRENTDBMD5" == "$COMPAREDBMD5" ]; then
    echo -e "Files are the same, and do not need to be backed up
   	     \t ### Exiting script ###\n"
else
    echo "The current database has changed. A backup will be created"
    cp ./Database.kdbx ./Database-$(date +"%Y%m%d-%H%M%S").kdbx
    echo Database-$(date +"%Y%m%d-%H%M%S").kdbx "was created at" $(date +"%Y-%m-%d-%H:%M:%S") >> ./database-creation-$(date +"%Y%m%d").log
fi

### 	This is a simple log message that will be added to database-creation.log 									###
### 	e.g. Database-20190820-161438.kdbx was created at 2019-08-20-16:14:38    									###
