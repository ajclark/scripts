#!/bin/sh

# Backup Maildirs to Amazon S3
# Written by Allan Clark - <napta2k@gmail.com>
# 2009-07-06

day=$(date +%A).tar.bz2
bucket="s3://s3.st0len.co.za/"

function s3alert () {
	mail -s "Backup failure on: ${HOSTNAME}" napta2k@gmail.com
	exit 1
}

tar -cjf /root/Maildir-${day} /data/Maildir || s3alert
s3cmd put /root/Maildir-${day} ${bucket} || s3alert
rm /root/Maildir-${day} || s3alert
