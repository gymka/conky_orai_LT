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
#/bin/bash
data=$(sed -n '/5 Day Forecast<\/h2>/,/10 Day Forecast/p' oras.htm>oras2.txt)
temp=$(cat oras2.txt|grep wx-temp|sed -n 's/.* \([0-9,-]*\)<.*/\1/p')
echo $temp
cond=$(cat oras2.txt|sed -n 's/<img src=.*wxicon\/100\/\([0-9]*\).png.*class="wx-weather-icon">/\1/p')
echo $cond
wind=$(cat oras2.txt|grep -a2 "<dt>Wind:</dt>"|sed -n 's/\(.*\)km.*/\1\n/p')
echo -e $wind

