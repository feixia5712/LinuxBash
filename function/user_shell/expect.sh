第一种直接发送命令
EXPECT="ssh -p22 root@1.1.1.1"  能够实现免密登录
expect <<EOF|tee /tmp/xx.log
set timeout 1s
spawn ${EXPECT}
expect {
       ">"{send "ping 1.1.1.1\r";}
        }
expect {
       "" {send "quit\r";}
expect eof

EOF
       
       
       
