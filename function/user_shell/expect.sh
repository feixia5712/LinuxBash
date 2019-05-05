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

第二种传入账号密码
expect -c "
     spawn ssh -p22 root@1.1.1.1
     expect {
          \"*(yes/no)\"
               {
               exp_send \"yes\";
               expect \"password:\";
                       {
                          exp_send \"${pass}\r\"
                          expect \"*#\" {send \"sh ${path}/install_agent.sh \r\"}
                       
                       }
               }
               
           \"*password:\"
                {
                send \"${pass}\r\";
                expect \"*#\" {send \"sh ${path}/install_agent.sh \r\"}
                }
            }
       expect \"root*\" {send \"exit\r\"}
       expect eof
       send_user \"eof1\n"
"
       
       
       
