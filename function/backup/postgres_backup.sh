#!/bin/bash
#### BEGIN CONFIGURATION ####
USER="`id -un`"
LOGNAME="$USER"
if [ $UID -ne 0 ]; then
fi
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
# set dates for backup rotation
DAYS=4
# set backup directory variables
BACKUP_D=/data/backup_postgres/
BACKUPDIR=$BACKUP_D`date +\%Y\%m\%d`
# database access details
export PGPASSWORD=xxxxx
HOST='10.25.12.94'
PORT='5432'
USER='postgres'
EMAIL_ADDRESS=571288304@qq.com
EMAIL_PY=/usr/local/bin/alterscript_msmtp.py
remote_destination_backup_datadir=/data/backup/backup_postgres
#Remote backup server
remote_backup_server="root@10.31.63.8"
ssh_option="-i /etc/ssh/ssh_host_rsa_key -p 22 -oStrictHostKeyChecking=no"
datadir_to_backup_log=/tmp/backuplog
# database access details
DBLIST=`psql -l -h$HOST -p$PORT -U$USER \
| awk '{print $1}' | grep -v "+" | grep -v "Name" | \
grep -v "List" | grep -v "(" | grep -v "template" | \
grep -v "postgres" | grep -v "root" | grep -v "|" | grep -v "|"`
[ -x $datadir_to_backup_log]||mkdir -p $datadir_to_backup_log
# get list of databases
for DBNAME in ${DBLIST}
do
#echo $DBNAME
pg_dump -h$HOST -p$PORT -U$USER $DBNAME |gzip > $BACKUPDIR/${DBNAME}_FULL.sql.gz
[ $? -eq 0 ]&& echo "${DBNAME}_FULL backup successfully!"||python $EMAIL_PY $EMAIL_ADDRESS "backup fail"
pg_dump -s -h$HOST -p$PORT -U$USER $DBNAME |gzip > $BACKUPDIR/${DBNAME}__SCHEMA.sql.gz
[ $? -eq 0 ]&& echo "${DBNAME}_SCHEMA backup successfully!"||python $EMAIL_PY $EMAIL_ADDRESS "backup fail"
done
 
#restore
#cat your_dump.sql | psql -h$HOST -p$PORT -U$USER $DBNAME
 
#del backup
find $BACKUP_D -type d -mtime +$DAYS -print|xargs rm -rf {}
[ $? -eq 0 ]&& echo "del backup successful"||python $EMAIL_PY $EMAIL_ADDRESS "del backup fail"
#rsync
rsync_postgres(){
ssh ${ssh_option} ${remote_backup_server} "test -d $remote_destination_backup_datadir || mkdir -p $remote_destination_backup_datadir"
rsync -azur \
    -e "ssh $ssh_option" \
    --log-file=${datadir_to_backup_log}/backup_filesystem_rsync_`date +\%Y\%m\%d`.log \
    ${BACKUPDIR} \
    ${remote_backup_server}:${remote_destination_backup_datadir}/
}
rsync_postgres
