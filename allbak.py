#!/usr/bin/python
# --coding:utf-8--
import sys
import MySQLdb
import math
import time
import os
import readline
import getpass
db = sys.argv[1]
now_day=time.strftime("%Y-%m-%d", time.localtime())
page_c=20000
print now_day
u = raw_input('user:')
p = getpass.getpass('password:')
link = MySQLdb.connect("localhost", u, p, db, charset='utf8')
cursor = link.cursor()
cursor.execute('show tables')
tables = cursor.fetchall()
maindir = '/data/mysql_bak/'+now_day+'/'+db+'/'
for i in tables:
	name = i[0]
	page = 0
	rs = cursor.execute('select count(*) as c from `'+db+'`.`'+name+'`')
	total = cursor.fetchone()
	paget = math.ceil(float(total[0])/page_c)
	savedir = maindir+name
	if not os.path.exists(savedir):
		os.makedirs(savedir)
		os.chown(savedir, 27, 27) #mysql uid,gid=27
	print '导出表结构', db, '-', name
	os.system('mysqldump -u'+u+' -p'+p+' -d '+db+' '+name+' > '+savedir+'/'+db+'_'+name+'.desc')
	os.system("sed -i '/^\(\/\*!\|--\|$\)/d' "+savedir+'/'+db+'_'+name+".desc")
	while page<paget:
		a=page*page_c
		filename=savedir+'/'+str(page)+'.txt'
		print db, '-', name, '-', page, 'limit', a, page_c
		if not os.path.isfile(filename):
			cursor.execute("select * from `"+db+"`.`"+name+"` limit "+str(a)+","+str(page_c)+" into outfile '"+filename+"' fields terminated by ',' LINES TERMINATED BY '\n'")
			time.sleep(0.5)
		page=page+1
#for 结束
link.close()
if os.path.exists(maindir):
	print '正在打包文件'
	os.chdir('/data/mysql_bak/')
	os.system('tar -zcf /data/mysql_bak/'+now_day+'/'+now_day+'-'+db+'.tar.gz '+now_day+'/'+db+'/')
	time.sleep(0.5)
	print '完成'
	os.system('rm -rf '+maindir)
