#ftp常用的下载的2种方式

Ftp_Ip='1.1.1.1'
Ftp_port='21'
Ftp_User='ftp'
Ftp_Password='123456'
Ftp_Path='/var/ftp/pub'  #这里是要下载文件的绝对路径并不是ftp的家目录
Ftp_File='ftp_file'

function Ftp_File{
   ftp -n <<EOF
   open ${Ftp_Ip} ${Ftp_Port}
   user ${Ftp_User} ${Ftp_Password}
   binary
   cd ${Ftp_Path}
   get ${Ftp_File}
   bye
   EOF
}


#第二种wget

Ftp_Pwd='/software/ftp_file' #ftp家目录下载的文件路径

wget --ftp-user=${Ftp_User} --ftp-password=${Ftp_Password} ftp://${Ftp_Ip}/${Ftp_Pwd} -o /dev/null


