#!/bin/bash

#-----------------------------------------------------------------------------------------
# This is a script to backup all your databases separately and delete old directories
# It is developed from dloghis (if you like it please leave the comment)
# Name your script "mysql-dump.sh" and place your script the directory /root/cron-scripts/
# Add the following two lines in cron without the comment sign "#" for every day backup
#
# MAILTO=user@yourdomain.gr
# 0 4 * * * /root/cron-scripts/mysql-dump.sh
#-----------------------------------------------------------------------------------------

# Remember if someone can read your script he will know the MySQL root password
SERVERIP=$(hostname -i)                 # Your Server IP
SERVERHOSTNAME=$(hostname -A)           # Your Server Host Name just for info if you have multiple servers (-A long , -s sort hostname)
DB_BACKUP="/root/db_backup"             # Dir for backup files like this "/root/db_backup"
TMP=$DB_BACKUP/tmp                      # Temp folder where databases are dumped
DB_USER="root"                          # mySQL user name usally root for all dbs
DB_PASSWD="xxxxxx"                      # Password of mySQL
adate=$(date +%Y-%m-%d_%H:%M:%S)        # Time that script starts
DATABASES=`mysql -u $DB_USER -p$DB_PASSWD -e 'show databases' -s --skip-column-names`

# Dump parameters in order to avoid mysql go offline
COMMAND01="--single-transaction --quick --lock-tables=false"

# Title and Version
echo "*-----------------------------------*"
echo "*    MySQL Dump-onedb V-20171208    *"
echo "*-----------------------------------*"
echo "Server Name: "$SERVERHOSTNAME "IP="$SERVERIP
echo "Starting script in: "$adate
echo ""

# List your databases
echo "Your Databases are:"
echo $DATABASES
echo ""
echo ""
echo -n "Please enter Database name to dump : "
read db
echo ""

echo "Creating new Backup of $db in "$TMP
echo ""

date=`date +%Y-%m-%d_%H.%M`

  # echo this to help you copy paste the command 
  echo "Dumping in gzip format, Uncompress with: gunzip -c $date-$db.sql.gz > $date-$db.sql"

  /usr/bin/mysqldump $COMMAND01 -u $DB_USER -p$DB_PASSWD $db | gzip > $TMP/"$date-$db.sql.gz";

echo ""

# It's nice to have after a big dump clean memory, uncomment if you want it (read your OS Doc)
echo "Dropping Memory Cashe... is OFF"
# sync && echo 3 > /proc/sys/vm/drop_caches
echo ""

# It's nice to know after a big dump how much storage you have
echo "Your Disk space !!! is:"
df -h
echo ""

bdate=$(date +%Y-%m-%d_%H:%M:%S)          # Info for end time
echo "Job  Start  in:     "$adate
echo "All Done! End time: "$bdate         # Just to know how long it took
