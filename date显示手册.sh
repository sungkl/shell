#!/bin/bash

echo "显示年‐月‐日 date +%F" 
date +%F

echo '组合显示 date +"%Y%m%d %H:%M:%S"' 
date +'%Y%m%d %H:%M:%S'

echo "显示数字年(如:01 号) date +%Y" 
date +%Y

echo "显示小时(24 小时制) date +%H" 
date +%H

echo "显示分钟(00..59) date +%M" 
date +%M

echo "显示秒 date +%S" 
date +%S

echo "显示纳秒 date +%N" 
date +%N

echo "显示星期简称(如:Sun) date +%a"
date +%a

echo "显示星期全称(如:Sunday) date +%A" 
date +%A

echo "显示月份简称(如:Jan) date +%b" 
date +%b

echo "显示月份全称(如:January) date +%B" 
date +%B

echo "显示数字月份(如:12) date +%m" 
date +%m

echo "显示数字日期(如:01 号) date +%d" 
date +%d


