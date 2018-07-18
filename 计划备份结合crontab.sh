#!/bin/bash

dir='/root/backup'
if [ ! -d $dir ];then
  mkdir -p $dir
fi
tar -zcf /root/backup/backup-`date +%Y%m%d`.tar.gz /var/log

#crontab -e -u root #每周5 0点
#0 0 * * 5 /root/backup.sh
