#!/bin/bash
# -x Executable file
filename=/usr/local/test.txt 
if [ -x $filename ];
then
echo "The file is executable"
fi
#-e  如果 filename 存在，则为真
#-d 如果 filename 为目录，则为真
#-f 如果 filename 为常规文件，则为真
#-L 如果 filename 为符号链接，则为真
#-r 如果 filename 可读，则为真
#-w 如果 filename 可写，则为真
#string parameter
#-z 如果 string 长度为零，则为真
myvar=string
if [ -z $myvar ];then
echo "string length zero"
fi
#-n 如果 string 长度非零，则为真
#注意
arg=''

if [ -n $arg ];then
echo "print with argument"
fi
#>>>>>>>>print with argument
if [ -n "$arg" ];then
echo "print with argument"
fi

##这个是正确的>>没有任何输出,所以最好加上双引号
