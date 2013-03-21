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

miestas="Kaunas"

if [[ "$miestas" == "Vilnius" ]]
then
	url="http://www.weather.com/weather/5-day/Vilnius+LHXX0005:1:LH"
elif [[ "$miestas" == "Klaipėda" ]]
then
	url="http://www.weather.com/weather/5-day/Klaipeda+LHXX0008:1:LH"
elif [[ "$miestas" == "Šiauliai" ]]
then
	url="http://www.weather.com/weather/5-day/Siauliai+LHXX0009:1:LH"
elif [[ "$miestas" == "Panevėžys" ]]
then
	url="http://www.weather.com/weather/5-day/Panevezys+LHXX0007:1:LH"
else 
	url="http://www.weather.com/weather/5-day/Kaunas+LHXX0002:1:LH"
fi

wget --load-cookies cookie -O $kelias/oras.txt $url
data=$(sed -n '/5 Day Forecast<\/h2>/,/10 Day Forecast/p' $kelias/oras.txt>oras2.txt)
oras2=$(cat $kelias/oras2.txt)
temp=$(echo "$oras2"|grep wx-temp|sed -n 's/.* \([0-9,-]*\)<.*/\1/p'>$kelias/oru_prognoze.txt)
cond=$(echo "$oras2"|sed -n 's/<img src=.*wxicon\/100\/\([0-9]*\).png.*class="wx-weather-icon">/\1/p'>>$kelias/oru_prognoze.txt)
windd=$(echo "$oras2"|grep -a2 "<dt>Wind:</dt>"|sed -n 's/\(.*\) at \(.*\) km\/h/ \1 /p'>>$kelias/oru_prognoze.txt)
winds=$(echo "$oras2"|grep -a2 "<dt>Wind:</dt>"|sed -n 's/\(.*\) at \(.*\) km\/h/\2/p')
for i in $winds
do 
echo "scale=2; ${i}/3.6" | bc|sed 's/^\./0./;s/\./,/;s/$/ m\/s/'>>$kelias/oru_prognoze.txt
done

windd1=$(sed -n '16,20p' $kelias/oru_prognoze.txt)
windd=${windd1// S /P}
windd=${windd// N /Š}
windd=${windd// E /R}
windd=${windd// W /V}
windd=${windd// NE /ŠR}
windd=${windd// NW /ŠV}
windd=${windd// SE /PR}
windd=${windd// SW /PV}
windd=${windd// NNE /ŠŠR}
windd=${windd// SSW /PPV}
windd=${windd// WSW /VPV}
windd=${windd// SSE /PPR}
windd=${windd// ESE /RPT}
windd=${windd// ENE /RŠR}
windd=${windd// NNW /ŠŠV}
windd=${windd// WNW /VŠV}
windd=($windd)
for (( i=0; i <5; i++))
	do
		eil=$(echo 16+$i|bc)
		sed -i "$eil c\
		"${windd[$i]}"" $kelias/oru_prognoze.txt
done

for (( i=0; i <5; i++))
	do
		eil=$(echo 11+$i|bc)
		image=$(sed -n "${eil}p" $kelias/oru_prognoze.txt)
		ln -s $kelias/piktogramos/$image.png $kelias/$i.png
done
