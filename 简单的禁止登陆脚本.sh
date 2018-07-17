#!/bin/bash
#登陆错误3次禁止客户机访问
iplist=`awk '/Failed password/{x=NF-3;print $x}' /var/log/secure | awk '{ip[$1]++}END{for(i in ip){print ip[i],i}}' | awk '$1>3{print $2}'`

for i in $iplist
do
  #firewall-cmd  --permanent  --zone=drop  --add-source=$i
  grep -q "$i$" /etc/hosts.deny || echo "sshd:"$i >> /etc/hosts.deny
done
