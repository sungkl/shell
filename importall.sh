#!/bin/bash
#需要的数据库权限，例：grant SELECT,FILE,LOCK TABLES,DROP,CREATE on *.* to 'mysqlbak'@'localhost' identified by 'mysqlbak123..';flush privileges;
#数据库目录要使用绝对路径，例： bash importbak.sh /data/mysql_bak/rbac/ d1
folder=$1
db=$2
if [ -z "$db" -o ! -d "$folder" ];then
        echo '数据库目录错误';exit
fi
read -p '数据库用户名：' u
stty -echo
read -p '数据库密码：' p
stty echo
> /data/mysql_bak/error_import_${db}.log
for table in `ls $folder`
do
        f=$folder'/'$table
        desc=`ls ${f}/*.desc 2>/dev/null`
        if [ $? -eq 0 -a -d "$f" ];then
                desc_sql=`cat $desc`
                mysql -u${u} -p${p} -e "use $db;$desc_sql;" 2>>/data/mysql_bak/error_import_${db}.log
                if [ $? -ne 0 ];then
                        echo '表结构错误：'$table >> /data/mysql_bak/error_import_${db}.log
                else
                        for txt in `ls ${f}/*.txt 2> /dev/null`
                        do
                                echo $txt
                                mysql -uroot -p'123456' -e "LOAD DATA INFILE  '${txt}' IGNORE INTO TABLE ${db}.${table} CHARACTER SET UTF8 FIELDS TERMINATED BY ',' LINES TERMINATED BY '\n';" 2>>/data/mysql_bak/error_import_${db}.log
                        done
                fi
        fi
done
