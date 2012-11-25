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

if  [[ "$miestas" == "Vilnius" ]]
then
	#Vilnius
	miestas=(1 6 11 16 21 26 31 36 41 46) #puslapis kartais rodo 4 dienas kartais 5. scenarijus ima 5 nepaisant to ar yra tokia info
elif [[ "$miestas" == "Klaipėda" ]]
then
	#Klapėda
	miestas=(3 8 13 18 23 28 33 38 43 48)
elif [[ "$miestas" == "Šiauliai" ]]
then
	#Šiauliai
	miestas=(4 9 14 19 24 29 34 39 44 49)
elif [[ "$miestas" == "Panevėžys" ]]
then
	#Panevėžys
	miestas=(5 10 15 20 25 30 35 40 45 50)
else 
	#Kaunas
	miestas=(2 7 12 17 22 27 32 37 42 47)
fi

temperatura=$(cat $kelias/oras.txt |sed  -n 's/.*t_plius\">\(.*\)<\/span>.*\|.*t_minus\">\(.*\)<\/span>.*/\1\2/p' | sed -n -e ${miestas[0]}'p' -e ${miestas[1]}'p' -e ${miestas[2]}'p' -e ${miestas[3]}'p' -e ${miestas[4]}'p' -e ${miestas[5]}'p' -e ${miestas[6]}'p' -e ${miestas[7]}'p' -e ${miestas[8]}'p' -e ${miestas[9]}'p'|tr ' ' '\n'>$kelias/temp.txt)

dangus=$(cat $kelias/oras.txt | sed -n 's/.*graf_zenklai\/met_reiskiniai\/\(.*\)\.gif\".*$/\1/p'|sed -n -e ${miestas[0]}'p' -e ${miestas[1]}'p' -e ${miestas[2]}'p' -e ${miestas[3]}'p' -e ${miestas[4]}'p' -e ${miestas[5]}'p' -e ${miestas[6]}'p' -e ${miestas[7]}'p' -e ${miestas[8]}'p' -e ${miestas[9]}'p'|tr ' ' '\n'>$kelias/dangus.txt)

diena=$(cat $kelias/oras.txt | sed -n 's/.*sav_diena\">\(.*\)<\/span>.*/\1/p'>$kelias/diena.txt)
diena=($(<$kelias/diena.txt))
if [[ -z ${diena[4]} ]]; then
	sed -i '5 i\
???' $kelias/diena.txt
fi
y=1
t=($(<$kelias/temp.txt))
d=($(<$kelias/dangus.txt))
if [[ -z "${t[8]}" ]]; then #jei rodo tik 4 dienas, 5-ai rodyt klaustukus
	t[8]='???'
	t[9]='???'
	d[8]='???'
	d[9]='???'
fi

for i in  ${miestas[@]};
do	
	ln -s -f "$kelias/piktogramos/${d[$y-1]}.png" "$kelias/$y.png"
	let y=y+1
done
rm $kelias/oras.txt
