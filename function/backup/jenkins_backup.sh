#!/bin/bash
--------------------
jenkins打包的时候使用脚本自动备份上次的包文件,
包文件默认保留10份，并且也会定期删除,但是实现了保证备份的数量保持不变
以便于我们恢复
-------------------
war_dir=/data/wwwroot
back_dir=/data/backup
jenkins_backup(){
cp -r $war_di/bs-im $back_dir
cd $back_dir
tar -zcf bs-im-`date +%Y-%m-%d-%H-%M-%S`.tar.gz bs-im
rm -rf bs-im

}

del_jenkins_backup(){
 backup_count_default=${1:-15}
 expired_num=$(find $/data/backup -name "*.tar.gz"|wc -l)
 if [ $expired_num -gt $backup_count_default ];then
 last_count=$((${expired_num} - ${backup_count_default}))
 find $back_dir -name "*.tar.gz" -printf "%C@ %p\n"|sort -n|awk -F " " '{print $2}'|head -$last_count|xargs rm -rf
fi

}

main(){
jenkins_backup
del_jenkins_backup
}
main
