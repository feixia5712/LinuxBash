USER="`id -un`"

LOGNAME="$USER"

if [ $UID -ne 0 ]; then

    echo "WARNING: Running as a non-root user, \"$LOGNAME\". Functionality may be unavailable. Only root can use some commands or options"

fi

PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games"

mysql_host=192.168.100.127

mysql_port=3306

mysql_username=root

mysql_password==xxxxx

mysql_basedir=/usr

mysql_bin_mysql=${mysql_basedir}/bin/mysql

mysql_bin_dump=${mysql_basedir}/bin/mysqldump

mysql_backup_dir=/data/backup/mysql/dbdata



date_format_type_dir=$(date +%Y-%m-%d)

date_format_type_file=$(date +%Y%m%d%H%M%S)



[ -d ${mysql_basedir} ] && mysql_datadir=${mysql_basedir}/data || mysql_datadir=/var/lib/mysql

[ -x ${mysql_bin_mysql} ] || mysql_bin_mysql=mysql

[ -x ${mysql_bin_dump} ] || mysql_bin_dump=mysqldump

[ -d ${mysql_backup_dir}/${date_format_type_dir} ] || mkdir -p ${mysql_backup_dir}/${date_format_type_dir}


mysql_databases_list=""

if [ -d ${mysql_datadir} ]; then

    mysql_databases_list=`ls -p ${mysql_datadir} | grep / |tr -d /`

else

    mysql_databases_list=$(${mysql_bin_mysql} -h${mysql_host} -P${mysql_port} -u${mysql_username} -p${mysql_password} \
-e "show databases;" |& grep -Eiv '(^database$|information_schema|performance_schema|mysql)')
fi


saved_IFS=$IFS

IFS=' '$'\t'$'\n'


for mysql_database in ${mysql_databases_list};do


    ${mysql_bin_dump} --host=${mysql_host} --port=${mysql_port} --user=${mysql_username} --password=${mysql_password}\
        --routines --events --triggers --single-transaction --flush-logs \
        --ignore-table=mysql.event --databases ${mysql_database} |& \
        gzip > ${mysql_backup_dir}/${date_format_type_dir}/${mysql_database}-backup-${date_format_type_file}.sql.gz

    [ $? -eq 0 ] && echo "${mysql_database} backup successfully! " || \
        echo "${mysql_database} backup failed! "

    /bin/sleep 2

    ${mysql_bin_dump} --host=${mysql_host} --port=${mysql_port} --user=${mysql_username} --password=${mysql_password}\
         --routines --events --triggers --single-transaction --flush-logs \
         --ignore-table=mysql.event --databases ${mysql_database} --no-data |& \
         gzip > ${mysql_backup_dir}/${date_format_type_dir}/${mysql_database}-backup-${date_format_type_file}_schema.sql.gz

    [ $? -eq 0 ] && echo "${mysql_database} schema backup successfully! " || \
        echo "${mysql_database} schema backup failed! "

    /bin/sleep 2

done

IFS=${saved_IFS}



save_days=${save_old_backups_for_days:-10}

need_clean=$(find ${mysql_backup_dir} -mtime +${save_days} -not -name $0 -exec ls '{}' \;)

    if [ ! -z "${need_clean}" ]; then

        find ${mysql_backup_dir} -mtime +${save_days} -not -name $0 -exec rm -rf '{}' \;

        echo "$need_clean have been cleaned! "

    else

        echo "nothing can be cleaned, skipped! "

    fi

