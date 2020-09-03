#!/bin/bash

# Check if user is root
if [ $(id -u) != "0" ]; then
    echo "Error: You must be root to run this script, please use root to install"
    exit 1
fi

echo "========================================================================="
echo "A tool to auto-compile & install MySQL 8.0.x on Redhat/CentOS Linux "
echo "========================================================================="

# check installed mysql or not
for i in `rpm -qa | grep "mysql"`
do 
rpm -e --allmatches $i --nodeps
done

# Remove pre-installed on OS MariaDB if exists

for i in $(rpm -qa | grep mariadb | grep -v grep)
do
  echo "Deleting rpm --> "$i
  rpm -e --nodeps $i
done


#install packages
yum install -y wget

function InstallMySQL8()
{
echo "============================Install MySQL 8.0.12=================================="

cd /usr/local/src

wget http://mirrors.163.com/mysql/Downloads/MySQL-8.0/mysql-8.0.20-linux-glibc2.12-x86_64.tar.xz

#Backup old my.cnf
if [ -s /etc/my.cnf ]; then
    mv /etc/my.cnf /etc/my.cnf.`date +%Y%m%d%H%M%S`.bak
fi
 
echo "============================MySQL 8.0.12 installing…………========================="
#mysql directory configuration
echo "tar mysql....."
tar Jxvf mysql-8.0.20-linux-glibc2.12-x86_64.tar.xz
mv mysql-8.0.20-linux-glibc2.12-x86_64 /usr/local/mysql

#edit /etc/my.cnf
echo "update my.cnf"

cat >>/etc/my.cnf<<EOF
[mysqld]

server-id                      = 224
port                           = 3306
mysqlx_port                    = 33060
mysqlx_socket                  = /tmp/mysqlx.sock
datadir                        = /data/mysql
socket                         = /tmp/mysql.sock
pid-file                       = /tmp/mysqld.pid
auto_increment_offset          = 2
auto_increment_increment       = 2 
log-error                      = error.log
slow-query-log                 = 1
slow-query-log-file            = slow.log
long_query_time                = 0.2
log-bin                        = bin.log
relay-log                      = relay.log
binlog_format                 =ROW
relay_log_recovery            = 1
character-set-client-handshake = FALSE
character-set-server           = utf8mb4
collation-server               = utf8mb4_unicode_ci
init_connect                   ='SET NAMES utf8mb4'
innodb_buffer_pool_size        = 1G
join_buffer_size               = 128M
sort_buffer_size               = 2M
read_rnd_buffer_size           = 2M
log_timestamps                 = SYSTEM
lower_case_table_names         = 1
default-authentication-plugin  =mysql_native_password
skip-external-locking
sql_mode = "STRICT_TRANS_TABLES,NO_ENGINE_SUBSTITUTION,NO_ZERO_DATE,NO_ZERO_IN_DATE,ERROR_FOR_DIVISION_BY_ZERO"
max_allowed_packet = 1M
net_buffer_length = 8K
read_rnd_buffer_size = 512K
key_buffer_size = 512M
table_open_cache = 2048
sort_buffer_size = 8M
read_buffer_size = 8M
myisam_sort_buffer_size = 128M
thread_cache_size = 256
tmp_table_size = 256M
explicit_defaults_for_timestamp = true
max_connections = 1000
max_connect_errors = 100
open_files_limit = 65535
#expire_logs_days = 10
binlog_expire_logs_seconds = 3600
early-plugin-load = ""
default_storage_engine = InnoDB
innodb_data_home_dir = /data/mysql
innodb_data_file_path = ibdata1:10M:autoextend
innodb_log_group_home_dir = /data/mysql
innodb_buffer_pool_size = 2048M
innodb_log_file_size = 512M
innodb_log_buffer_size = 8M
innodb_flush_log_at_trx_commit = 1
innodb_lock_wait_timeout = 50
innodb_file_per_table = 1
EOF

echo "add mysqluser and other dir"

groupadd mysql -g 512
useradd -u 512 -g mysql -s /sbin/nologin -d /home/mysql mysql
mkdir -p /data/mysql
chown -R mysql:mysql /data/mysql
chmod -R 775 /data/mysql/
chown -R mysql:mysql /usr/local/mysql
  
echo "init mysql......"

/usr/local/mysql/bin/mysqld --user=mysql --basedir=/usr/local/mysql --datadir=/data/mysql --initialize-insecure

cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysql
 
/etc/init.d/mysql start

echo "add env mysql path....."
cat >>/etc/profile.d/mysql.sh<<EOF
export PATH=$PATH:/usr/local/mysql/bin
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/mysql/lib
EOF

source /etc/profile.d/mysql.sh
. /etc/profile.d/mysql.sh
echo $PATH

cat >>/tmp/mysql_sec_script<<EOF
use mysql;
ALTER USER 'root'@'localhost' IDENTIFIED BY '123456';
create user root@'%' identified by '123456';
GRANT all ON *.* TO 'root'@'%';
FLUSH PRIVILEGES;
EOF
echo "看见password请输入enter键......"
/usr/local/mysql/bin/mysql -u root -p -h localhost < /tmp/mysql_sec_script
/etc/init.d/mysql restart
mysqld --version
systemctl stop firewalld.service
systemctl disable firewalld.service
 
echo "============================MySQL 8.0.12 install completed========================="
}

function CheckInstall()
{

echo "===================================== Check install ==================================="
#clear
echo "Checking..."
 
if [ -s /usr/local/mysql/bin/mysql ] && [ -s /usr/local/mysql/bin/mysqld_safe ] && [ -s /etc/my.cnf ]; then
  echo "MySQL: OK"
  num=`netstat -anp|grep -w 3306|wc -l`
  if [ $num -eq 1 ];then
     echo "mysql start success"
  else
    echo "mysql start faild..."
    echo "please cat /data/mysql/error.log...."
    exit 1
  fi
  else
  echo "Error: /usr/local/mysql not found!!!MySQL install failed."
     exit 1
fi

}

function MysqlInfo(){

  echo -e "\033[32m =========================================================================
  =========Congratulations,Mysql install success!!! Information.....=======
 
        datadir:/data/mysql
        basedir:/usr/local/mysql
        port:3306
        password:123456
        connect:mysql -uroot -p123456
        error.log:/data/mysql/error.log   
  
  =========================================================================\033[0m"
  
}

InstallMySQL8
CheckInstall
MysqlInfo
