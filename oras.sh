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
kelias=/home/gymka/Dev/conky_orai_LT
. $kelias/config
IFS='
'
rm $kelias/oras.txt 

wget -O $kelias/oras.txt 'http://meteo.lt/oru_prognoze.php'
temperatura=$(grep "<span class = \"oplm_t_" $kelias/oras.txt|sed -n 's/.*\">\([0-9,-]*\) .*/\1/p'>$kelias/temp.txt)
dangus=$(grep "<img src=\"prog_failai/graf_zenklai/.*\.gif\" alt=\".*\" title=\".*\" />" $kelias/oras.txt|sed 's/<img src=\"prog_failai\/graf_zenklai\/met_reiskiniai\/\(.*\).gif\" alt.*/\1/'|sed 's/<.*>//'|sed 's/[\t ]*//g'>$kelias/dangus.txt)

if  [[ "$miestas" == "Vilnius" ]]
then
	#Vilnius
	sed -n '1,6p' $kelias/temp.txt>$kelias/temp1.txt
	sed -n '7,13p' $kelias/temp.txt>$kelias/temp2.txt
	paste -d \\n $kelias/temp1.txt $kelias/temp2.txt>$kelias/temp.txt
	sed -n '1,6p' $kelias/dangus.txt>$kelias/dangus1.txt
	sed -n '7,13p' $kelias/dangus.txt>$kelias/dangus2.txt
	paste -d \\n $kelias/dangus1.txt $kelias/dangus2.txt>$kelias/dangus.txt
elif [[ "$miestas" == "Klaipėda" ]]
then
	#Klapėda
	sed -n '25,30p' $kelias/temp.txt>$kelias/temp1.txt
	sed -n '31,36p' $kelias/temp.txt>$kelias/temp2.txt
	paste -d \\n $kelias/temp1.txt $kelias/temp2.txt>$kelias/temp.txt
	sed -n '25,30p' $kelias/dangus.txt>$kelias/dangus1.txt
	sed -n '31,36p' $kelias/dangus.txt>$kelias/dangus2.txt
	paste -d \\n $kelias/dangus1.txt $kelias/dangus2.txt>$kelias/dangus.txt
elif [[ "$miestas" == "Šiauliai" ]]
then
	#Šiauliai
	sed -n '37,42p' $kelias/temp.txt>$kelias/temp1.txt
	sed -n '43,48p' $kelias/temp.txt>$kelias/temp2.txt
	paste -d \\n $kelias/temp1.txt $kelias/temp2.txt>$kelias/temp.txt
	sed -n '37,42p' $kelias/dangus.txt>$kelias/dangus1.txt
	sed -n '43,48p' $kelias/dangus.txt>$kelias/dangus2.txt
	paste -d \\n $kelias/dangus1.txt $kelias/dangus2.txt>$kelias/dangus.txt
elif [[ "$miestas" == "Panevėžys" ]]
then
	#Panevėžys
	sed -n '49,54p' $kelias/temp.txt>$kelias/temp1.txt
	sed -n '55,60p' $kelias/temp.txt>$kelias/temp2.txt
	paste -d \\n $kelias/temp1.txt $kelias/temp2.txt>$kelias/temp.txt
	sed -n '49,54p' $kelias/dangus.txt>$kelias/dangus1.txt
	sed -n '55,60p' $kelias/dangus.txt>$kelias/dangus2.txt
	paste -d \\n $kelias/dangus1.txt $kelias/dangus2.txt>$kelias/dangus.txt
else 
	#Kaunas
	sed -n '13,18p' $kelias/temp.txt>$kelias/temp1.txt
	sed -n '19,24p' $kelias/temp.txt>$kelias/temp2.txt
	paste -d \\n $kelias/temp1.txt $kelias/temp2.txt>$kelias/temp.txt
	sed -n '13,18p' $kelias/dangus.txt>$kelias/dangus1.txt
	sed -n '19,24p' $kelias/dangus.txt>$kelias/dangus2.txt
	paste -d \\n $kelias/dangus1.txt $kelias/dangus2.txt>$kelias/dangus.txt
fi
rm $kelias/temp1.txt $kelias/temp2.txt $kelias/dangus2.txt $kelias/dangus1.txt
diena=$(grep -m 1 "span class=\"oplm_sav_diena\">.*</span>" $kelias/oras.txt |sed 's/<\/span>/\n/g'|sed 's/<.*>//'|sed 's/[\t ]*//g'>$kelias/diena.txt)
diena=($(<$kelias/diena.txt))
y=1
d=($(<$kelias/dangus.txt))

for ((i=0; i<14; i++))
do	
	ln -s -f "$kelias/piktogramos/${d[$y-1]}.png" "$kelias/$y.png"
	let y=y+1
done
rm $kelias/oras.txt
