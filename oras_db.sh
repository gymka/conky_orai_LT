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
	
	Copyright (C) 2012 gymka <gymka@archlinux.lt>'
kelias=$(dirname ${BASH_SOURCE[0]})

miestas="Kaunas"

if [[ "$miestas" == "Vilnius" ]]
then
	addr_now="http://www.weather.com/weather/right-now/Vilnius+LHXX0005:1:LH"
elif [[ "$miestas" == "Klaipėda" ]]
then
	addr_now="http://www.weather.com/weather/right-now/Klaipeda+LHXX0008:1:LH"
elif [[ "$miestas" == "Šiauliai" ]]
then
	addr_now="http://www.weather.com/weather/right-now/Siauliai+LHXX0009:1:LH"
elif [[ "$miestas" == "Panevėžys" ]]
then
	addr_now="http://www.weather.com/weather/right-now/Panevezys+LHXX0007:1:LH"
else 
	addr_now="http://www.weather.com/weather/right-now/Kaunas+LHXX0002:1:LH"
fi

wget --tries=10 --retry-connrefused --wait=1 --user-agent="Firefox" --load-cookies $kelias/cookie -O $kelias/oras_db.txt $addr_now

time12=$(grep -o -m 1 'updated">.*Local Time' $kelias/oras_db.txt|sed  's/.*[0-9]\{4\}, \(.*\)Local.*/\1/')
time24=$(date -d $time12 +%H:%M>oras_db_data.txt)
temp=$(grep -m1 'itemprop="temperature-celsius">' oras_db.txt|sed -n 's/.*celsius">\(.*\)<\/span.*/\1/p'>>oras_db_data.txt)
sky=$(grep -m1 'itemprop="weather-phrase">' oras_db.txt|sed -n 's/.*phrase">\(.*\)<\/span.*/\1/p'>>oras_db_data.txt)
wind=$(sed -n '/<div class="wx-data-part wx-first wx-wind">/,/km\/h<\/div>/p' oras_db.txt)
wind_dir=$(echo $wind|sed -n 's/.*>\(.*\) at.*/\1/p'>>oras_db_data.txt)
wind_speed=$(echo $wind|sed -n 's/.*>.*at\(.*\)km.*<\/div>/\1/p')
wind_m=$(echo "scale=2; $wind_speed/3.6" | bc|sed 's/^\./0./'>>oras_db_data.txt)
hum=$(grep -m1 -A1 'class="wx-label">Humidity' oras_db.txt|sed -n 's/.*wx-data">\(.*\)<\/div>/\1/p'>>oras_db_data.txt)
visi=$(grep -m1 -A1 'class="wx-label">Visibility' oras_db.txt|sed -n 's/.*wx-data">\(.*\)<\/div>/\1/p'>>oras_db_data.txt)
pres=$(grep -m1 -A2 'class="wx-label">Pressure' oras_db.txt|sed -n 's/ \(.*\)mb/\1mb/p'>>oras_db_data.txt)
uv=$(grep -m1 '<span class="wx-temp" itemprop="uv-index">' oras_db.txt|sed -n 's/<.*>\(.*\)<.*>/\1/p'>>oras_db_data.txt)
sed -i 's/\t//g;s/   //g' oras_db_data.txt
image=$(grep -m1 http://s.imwx.com/v.*/img/wxicon/ oras_db.txt|sed -n 's/.*\/\(.*\)\.png.*/\1/p')
cp $kelias/piktogramos/$image.png $kelias/now.png
$kelias/isverst_ora.sh

