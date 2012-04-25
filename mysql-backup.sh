#!/bin/sh

#------------------------------------------------------------------------------
# Title: MySQL backup script
#------------------------------------------------------------------------------
# Author: Allan Clark - http://github.com/ajclark/scripts/
#------------------------------------------------------------------------------
# Date: 2008-08-23
#------------------------------------------------------------------------------
# Comment:
#------------------------------------------------------------------------------
#       This script can perform a local or remote mysqldump.
#       This script supports both InnoDB and MyISAM table locking methods
#       After all databases are dumped they will be compressed and, if remote,
#       they will be securely copied to a remote host.
#------------------------------------------------------------------------------
# Usage:
#------------------------------------------------------------------------------
# Loocal mode:
#  All databases will be dumped to a single file and compressed.
#  local: ./mysql_backup.sh
#
# Remote mode:
#  This script will connect to the remote mysql server and
#  perform a mysqldump to the local server's disk.
#  remote: ./mysql_backup.sh remote-host.com
#------------------------------------------------------------------------------

#------------------------------------------------------------------------------
# MySQL variables
#------------------------------------------------------------------------------

# Uses ~/.my.cnf for secure password storage
mysqlUser=dump

#------------------------------------------------------------------------------
# File variables
#------------------------------------------------------------------------------

outputDir=/c/home/backups/mysql
defaultHost=localhost
lockTables="--lock-all-tables"			# Aquire GLOBAL READ LOCK
# lockTables="--single-transaction"		# Uncomment for InnoDB tables
# lockTables=""							# Do not lock tables (DANGER!)
outputFile=$(date +%A).sql

#------------------------------------------------------------------------------
# Main code
#------------------------------------------------------------------------------

if [ -z $1 ]; then
   mysqldump -C $lockTables -u $mysqlUser -h ${1-$defaultHost} --all-databases | ssh -C user@remote-host.com "gzip -c > ${outputDir}/${HOSTNAME}-${outputFile}.gz"
else
   mysqldump -C $lockTables -u $mysqlUser -h ${1-$defaultHost} --all-databases | gzip -c > ${outputDir}/${1}-${outputFile}.gz
fi

