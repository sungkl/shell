#!/bin/bash

echo '1.启动Nginx'
echo '2.停止'
echo '3.重启'
echo '4.查询状态'
echo '输入其他退出'
echo '------------------'
read -p '请输入编号：' num

pgrep -x nginx &>/dev/null
ss=$?

case $num in
  1)
    [ $ss -ne 0 ] && /usr/local/nginx/sbin/nginx;; #启动start
  2)
    [ $ss -eq 0 ] && /usr/local/nginx/sbin/nginx -s stop;;#停止
  3)
    [ $ss -eq 0 ] && /usr/local/nginx/sbin/nginx -s stop
    /usr/local/nginx/sbin/nginx;;#重启
  4)
    if [ $ss -eq 0 ];then
      echo 'Nginx已启动'
    else
      echo 'Nginx未启动'
    fi
    ;;
  *)
    echo '退出';;
esac
