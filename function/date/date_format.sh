#!/bin/bash
date +"%F"  #2018-02-06
date +"%F-%H-%M-%S"  #2018-02-06-11-39-46
date +"%Y%m%d%H%M%S" #20180206114039
#时间戳
date +%s   #1518056137
date -d @1518056137 "+%Y-%m-%d" #2018-02-08
date -d "2018-02-08 00:00:00" +%s   #1518019200
