#!/bin/bash

###     From the database-backup script, this will script will be called with crontab move backups of           ###
###     the keepass Database to a separate directory                                                            ###


###	Setting the variables from this directory to the target directory					###

KEEPASSHOME=$HOME/keepass-database
LOG=$KEEPASSHOME/database-creation-$(date +"%Y%m%d").log
MONTHDIR=$KEEPASSHOME/database-backups/Databases-$(date +"%Y-%m")
DIR=$MONTHDIR/Databases-$(date +"%Y%m%d")

cd $KEEPASSHOME

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
