#!/bin/bash
: 'This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
	
	Copyright (C) 2012 gymka <gymka at archlinux.lt>'
	
kelias=$(dirname ${BASH_SOURCE[0]})
miestas=$(sed -n "1p" $kelias/miestas.txt)

wget --tries=10 --retry-connrefused --wait=1 --user-agent="Firefox" --load-cookies $kelias/cookie -O $kelias/oras.txt "http://www.weather.com/weather/5-day/$miestas"


data=$(sed -n '/5 Day Forecast<\/h2>/,/10 Day Forecast/p' $kelias/oras.txt>$kelias/oras2.txt)
oras2=$(cat $kelias/oras2.txt)
temp=$(echo "$oras2"|grep wx-temp|sed -n 's/.* \([0-9,-]*\)<.*/\1/p'>$kelias/oru_prognoze.txt)
cond=$(echo "$oras2"|sed -n 's/<img src=.*wxicon\/100\/\([0-9]*\).png.*class="wx-weather-icon">/\1/p'>>$kelias/oru_prognoze.txt)
windd=$(echo "$oras2"|grep -a2 "<dt>Wind:</dt>"|sed -n 's/\(.*\) at \(.*\) km\/h/ \1 /p')
winds=$(echo "$oras2"|grep -a2 "<dt>Wind:</dt>"|sed -n 's/\(.*\) at \(.*\) km\/h/\2/p')
for i in $winds
do 
echo "scale=2; ${i}/3.6" | bc|sed 's/^\./0./;s/\./,/;s/$/m\/s/'>>$kelias/oru_prognoze.txt
done
day=$(echo "$oras2"|grep "h3.*wx-label"|sed -n 's/.*">\(.*\)<\/.*/\1/p')
IFS='
'
for i in $day
	do
		date -d "$i" +%A >> $kelias/oru_prognoze.txt
done
windd=${windd// S /$(echo -e '\U2191')}
windd=${windd// N /$(echo -e '\U2193')}
windd=${windd// E /$(echo -e '\U2190')}
windd=${windd// W /$(echo -e '\U2192')}
windd=${windd// NE /$(echo -e '\U2199')}
windd=${windd// NW /$(echo -e '\U2198')}
windd=${windd// SE /$(echo -e '\U2196')}
windd=${windd// SW /$(echo -e '\U2197')}
windd=${windd// NNE /$(echo -e '\U2199')}
windd=${windd// SSW /$(echo -e '\U2197')}
windd=${windd// WSW /$(echo -e '\U2197')}
windd=${windd// SSE /$(echo -e '\U2196')}
windd=${windd// ESE /$(echo -e '\U2196')}
windd=${windd// ENE /$(echo -e '\U2199')}
windd=${windd// NNW /$(echo -e '\U2198')}
windd=${windd// WNW /$(echo -e '\U2198')}
windd=($windd)
for (( i=0; i <5; i++))
	do
		eil=$(echo 16+$i|bc)
		sed -i "${eil}s/\(.*\)/${windd[$i]} \1/" $kelias/oru_prognoze.txt
		eil2=$(echo 11+$i|bc)
		image=$(sed -n "${eil2}p" $kelias/oru_prognoze.txt)
		ln -s $kelias/piktogramos/$image.png $kelias/$i.png
done

