#/bin/bash
data=$(sed -n '/5 Day Forecast<\/h2>/,/10 Day Forecast/p' oras.htm>oras2.txt)
temp=$(cat oras2.txt|grep wx-temp|sed -n 's/.* \([0-9,-]*\)<.*/\1/p')
echo $temp
cond=$(cat oras2.txt|sed -n 's/<img src=.*wxicon\/100\/\([0-9]*\).png.*class="wx-weather-icon">/\1/p')
echo $cond
wind=$(cat oras2.txt|grep -a2 "<dt>Wind:</dt>"|sed -n 's/\(.*\)km.*/\1\n/p')
echo -e $wind

