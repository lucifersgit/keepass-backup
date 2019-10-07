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
    exit 1

else
    echo "The current database has changed. A backup will be created"
    cp ./Database.kdbx ./Database-$(date +"%Y%m%d-%H%M%S").kdbx
    echo Database-$(date +"%Y%m%d-%H%M%S").kdbx "was created at" $(date +"%Y-%m-%d-%H:%M:%S") >> ./database-creation-$(date +"%Y%m%d").log
fi

### 	This is a simple log message that will be added to database-creation.log 									###
### 	e.g. Database-20190820-161438.kdbx was created at 2019-08-20-16:14:38    									###

###     From the database-backup script, this will script will be called with crontab move backups of           ###
###     the keepass Database to a separate directory                                                            ###


###	Setting the variables from this directory to the target directory					###

LOG=$KEEPASSHOME/database-creation-$(date +"%Y%m%d").log
MONTHDIR=$KEEPASSHOME/database-backups/Databases-$(date +"%Y-%m")
DIR=$MONTHDIR/Databases-$(date +"%Y%m%d")

###     Linux find command with maxdepth of 1 (i.e. current directory)                                          ###
OLDDATABASE=$(find -maxdepth 1  -name "Database-$(date +"%Y%m%d")-*.kdbx")

### 	Check if the database-files exist from today (relative)							###

if [ -z "$OLDDATABASE" ]; then
	echo -e "Files do not exist or have been previously moved\n"
	echo -e "\t ### Exiting script ###\n"
	exit 1
else
	echo -e "Files exist. The following will be moved to the backup directory: "
	echo -e "\n$OLDDATABASE"
fi

###	Create directory if it does not exist									###

if [ -d "$MONTHDIR" ]; then	
	echo "Month directory Databases-$(date +"%Y-%m") already exists."
else
	echo "Creating month directory Databases-$(date +"%Y-%m")"
	mkdir $MONTHDIR
fi

if [ -d "$DIR" ]; then
	echo "Directory Databases-$(date +"%Y%m%d") already exists. Moving on..."
else
	echo "Creating directory Databases-$(date +"%Y%m%d")"
	mkdir $DIR
fi

##	Move database files and log file to target directory									###

echo "Moving files to target dirctory"

mv $OLDDATABASE $DIR
cat $LOG >> $DIR/database-creation-$(date +"%Y%m%d").log
rm $LOG
