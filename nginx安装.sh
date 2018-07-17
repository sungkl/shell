#!/bin/bash

ynum=`yum repolist | sed -n 's/,//g;$p' | awk '{print $2}'`
if [ $ynum -le 0 ];then
  echo 'yum不可用'
  exit 1
fi

yum -y install gcc openssl-devel pcre-devel

#wget nginx包或准备好本地包
nginx='nginx-1.12.1'
pack=$nginx'.tar.gz'

if [ -f $pack ];then
  id nginx &>/dev/null 
  if [ $? ‐ne 0 ];then 
    useradd ‐s /sbin/nologin nginx 
  fi
  tar -xf $pack 
  cd $nginx
  ./configure
  make && make install
  cd ..
  rm -rf $nginx
else
  echo '找不到Nginx包'
  exit 1
fi
