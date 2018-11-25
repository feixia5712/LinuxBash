#!/usr/local/src/Python-2.7.15/python
import string

import os 
import time
import re
import math
import sys
from optparse import OptionParser

print "Test by gongjia start..."


parser = OptionParser()
parser.add_option("-i", "--input", dest="input",action="store_true",help="input x y for each file by user")
parser.add_option("-q", "--quality", dest="q",action="store",help="input xvid q arg",default="24")
parser.add_option("-v", "--vcodec", dest="vcodec",action="store",help="input video codec",default="x264")
parser.add_option("-n", "--noaudio", dest="an",action="store_true",help="no audio")
parser.add_option("-p", "--preset", dest="preset",action="store",help="",default="")
parser.add_option("-m", "--maxWidth", dest="maxWidth",action="store",help="input max width for output video",default="")
parser.add_option("-f", "--fileType", dest="fileType",action="store",help="",default="mp4")
parser.add_option("-o", "--ogg", dest="ogg",action="store_true",help="user ogg instead of aac",default="")
parser.add_option("-3", "--mp3", dest="mp3",action="store_true",help="user mp3 instead of aac",default="")
parser.add_option("-1", "--pad", dest="pad",action="store_true",help="pad to 16:9",default="")
parser.add_option("-s", "--src", dest="srcD",action="store",help="source dir",default="/home/gongjia/external/ffmpeg/ffmpeg-x86/videoin")
parser.add_option("-t", "--target", dest="targetD",action="store",help="target dir",default="/home/gongjia/external/ffmpeg/ffmpeg-x86/videoout")
parser.add_option("-w", "--workdir", dest="workdir",action="store",help="work dir",default="/home/gongjia/external/ffmpeg/ffmpeg-x86/video")
parser.add_option("-e", "--split", dest="split",action="store_true",help="split to multiple file with size")
parser.add_option("-d", "--splitsize", dest="splitsize",action="store",help="split to multiple file with size",default="2")#Minutes
parser.add_option("-j", "--prefix", dest="prefix",action="store",help="target file name prefix",default="")

(options, args) = parser.parse_args()

if options.srcD==None or options.srcD[0:1]=='-':
    print 'srcD Err, quit'
    exit() 
if options.targetD==None or options.targetD[0:1]=='-':
    print 'targetD Err, quit'
    exit() 
if options.fileType==None or options.fileType[0:1]=='-':
    print 'fileType Err, quit'
    exit() 
if options.workdir==None or options.workdir[0:1]=='-':
    print 'workdir Err, quit'
    exit() 
    
#获取视频文件的名字
for root,dirs,files in os.walk(options.srcD): 
    for name in files:
        name= name.replace('[','''\[''')
        newname =name[0: name.rindex('.')]      
        print "Test newname: " + newname
        print "Test name: " + name
        cmd ='cd '+options.workdir+';mkdir -p ffm;  rm -f ffm/ffm.txt ; sh -c "(/usr/local/src/ffmpeg-git-20181015-64bit-static/ffmpeg -i '+options.srcD+'/' +name+ ' >& ffm/ffm.txt)"; grep Duration ffm/ffm.txt'
   #ffmpeg -i  xxx.mp4  能够得到视频文件的时间信息
        print cmd
        (si, so, se) = os.popen3(cmd)
        t=so.readlines() #['  Duration: 00:26:52.92, start: 0.000000, bitrate: 248 kb/s\n']
        print t 
        reg='''Duration\:\s(\d+)\:(\d+)\:([\d\.]+)'''
        duration=0#second
        for line in t:
            result = re.compile(reg).findall(line)  #result=[('00', '26', '52.92')]
            for c in result:
                print 'split file to',options.splitsize,'minutes, Duration:',c[0],c[1],c[2]
                duration = int(c[0])*3600 + int(c[1])*60+float(c[2])#获取视频全部时间s
                nameLength=int(math.log(int(duration / (int(options.splitsize)*60)) )/math.log(10)) + 1
                print nameLength
                for i in range(int(duration / (int(options.splitsize)*60)) + 1):#获取总计能够截取几份
                    print i
                    _t = ''
                    if duration>int(options.splitsize)*60*(i+1):#当总时间数大于截取时间数时的取值
                        _t = str(int(options.splitsize)*60)
                    else:
                        _t = str(duration-int(options.splitsize)*60*i)##当总时间数小于截取时间数时的取值也就是最后一段视频
                    cmd ='sh -c "' + "cd "+options.workdir+";touch ffm/output.log;(/usr/local/src/ffmpeg-git-20181015-64b
it-static/ffmpeg -y -i "+options.srcD+"/"+name+" -codec: copy -ss "+str(i*int(options.splitsize)*60)+" -t "+_t+" "+option
s.targetD+"/"+options.prefix+newname+'_'+string.replace(('%'+str(nameLength)+'s')%str(i),' ','0')+"."+options.fileType + 
' >& ffm/output.log)"'
                    print cmd
                    (si, so, se) = os.popen3(cmd)
                    for line in se.readlines() :#
                        print line
