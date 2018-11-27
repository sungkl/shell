#!/bin/bash
#完全备份脚本
db=$1
if [ -z $db ];then
	echo '未选择数据库';exit
fi
u='mysqlbak'
p='mysqlbak123..'
tables=`mysql -u${u} -p"${p}" -e "use ${db};show tables;"`
#echo $tables
i=0
now_day=`date +'%Y-%m-%d'`
page_c=10000
echo $now_day
for name in $tables
do
    if [ $i -ne 0 ];then
        page=0;  #页码 0等于第一页
        total=`mysql -u${u} -p"${p}" -e "select count(*) from ${db}.${name}"`
        #total=`mysql -u${u} -p"${p}" -e "SELECT SQL_CALC_FOUND_ROWS 1 FROM ${db}.${name} LIMIT 0;SELECT FOUND_ROWS() AS rowcount;"`
        total=`echo $total | awk '{print $2}'`  #总记录数
        paget=$(awk -v x=${total} -v y=${page_c} 'BEGIN{print x/y}');
        paget=`echo $paget | awk '{print int($1)==($1)?int($1):int($1)+1}'` #总页数，向上取整
        dir="/data/mysql_bak/${now_day}/${db}/${name}"
        mkdir -p $dir
        chown -R mysql:mysql $dir
	echo '导出表结构'${db}' - '${name}
	mysqldump -u${u} -p${p} -d ${db} ${name} > ${dir}/${db}_${name}.desc
	sed -i '/^\(\/\*!\|--\|$\)/d' ${dir}/${db}_${name}.desc
        while (($page<$paget))
        do
            a=$[$page*$page_c]
            file="${dir}/${page}.txt"
            echo ${db}' - '${name}' - '$page' limit '$a','$page_c
            if [ ! -f $file ];then
				        mysql -u${u} -p"${p}" -e "select * from ${db}.${name} limit ${a},${page_c} into outfile '${file}' fields terminated by ',' LINES TERMINATED BY '\n'" 2>> ${dir}/error.log
				        sleep 1;
            fi
            let page=page+1;
		done
    fi
    let i++
done
if [ $i -gt 0 -a -d "/data/mysql_bak/${now_day}/${db}/" ];then
	echo '正在打包文件'
	cd /data/mysql_bak/
	tar -zcf /data/mysql_bak/${now_day}/${now_day}-${db}.tar.gz ${now_day}/${db}/
	sleep 1
	echo '完成'
	rm -rf /data/mysql_bak/${now_day}/${db}/
fi
