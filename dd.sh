#!/bin/bash
#判断网址是否联通，并发送钉钉警告
#rs=`curl -I 'http://网址'`
if [ -z $1 ];then
        exit;
fi
logname=`echo $1 | awk -F"/" '{print $(NF-1),$NF}' | sed 's/ /-/g'`
#echo $logname
curl -I --connect-timeout 50 -m 50 ${1} > ${logname}.log
tip=`head -1 ${logname}.log`
echo $tip | grep -q '200 OK'
b=$?
#echo $b
if [ $b -ne 0 ];then
        nowtime=`date +'%Y-%m-%d %H:%M'`
        tip="${nowtime}\r${logname}异常${tip}"
	      #echo $tip
        #exit
        url='https://oapi.dingtalk.com/robot/send?access_token=钉钉机器人token'
        curl $url -H 'Content-Type: application/json'  -d '{"msgtype": "text","text": {"content": "'"$tip"'"}}'
fi
