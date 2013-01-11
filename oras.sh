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
#konfigūracija
kelias=/home/gymka/Dev/conky_orai_LT
miestas="Kaunas"
IFS='
'

#duomenų gavimas ir apdorojimas
wget -O $kelias/oras.txt 'http://meteo.lt/oru_prognoze.php'
temperatura=$(grep "<span class = \"oplm_t_" $kelias/oras.txt|sed -n 's/.*\">\([0-9,+,-]*\) .*/\1/p'>$kelias/temp.txt)
dangus=$(grep "<img src=\"prog_failai/graf_zenklai/.*\.gif\" alt=\".*\" title=\".*\" />" $kelias/oras.txt|sed 's/<img src=\"prog_failai\/graf_zenklai\/met_reiskiniai\/\(.*\).gif\" alt.*/\1/'|sed 's/<.*>//'|sed 's/[\t ]*//g'>$kelias/dangus.txt)
diena=$(grep -m 1 "span class=\"oplm_sav_diena\">.*</span>" $kelias/oras.txt |sed 's/<\/span>/\n/g'|sed 's/<.*>//'|sed 's/[\t ]*//g'>$kelias/diena.txt)

function sukurt_miestu_masyva {
pridet=$(expr $1 - 2)

miestai=("${miestai[@]}" "1")
miestai=("${miestai[@]}" "$(expr 1 + ${pridet})")

for x in {2..19..2}
	do
		miestai=("${miestai[@]}" $(expr ${miestai[$x-1]} + 1))		
		miestai=("${miestai[@]}" $(expr ${miestai[$x]} + ${pridet}))
done
}

function palikt_tik_reikalingus_duomenis {
	sed -n "${1},${2}p" $kelias/temp.txt>$kelias/temp1.txt
	sed -n "${3},${4}p" $kelias/temp.txt>$kelias/temp2.txt
	paste -d \\n $kelias/temp1.txt $kelias/temp2.txt>$kelias/temp.txt
	sed -n "${1},${2}p" $kelias/dangus.txt>$kelias/dangus1.txt
	sed -n "${3},${4}p" $kelias/dangus.txt>$kelias/dangus2.txt
	paste -d \\n $kelias/dangus1.txt $kelias/dangus2.txt>$kelias/dangus.txt
}

sukurt_miestu_masyva $(wc -l <$kelias/diena.txt) 

if  [[ "$miestas" == "Vilnius" ]]
then
	#Vilnius
	palikt_tik_reikalingus_duomenis ${miestai[0]} ${miestai[1]} ${miestai[2]} ${miestai[3]}
elif [[ "$miestas" == "Klaipėda" ]]
then
	#Klapėda
	palikt_tik_reikalingus_duomenis ${miestai[8]} ${miestai[9]} ${miestai[10]} ${miestai[11]}
elif [[ "$miestas" == "Šiauliai" ]]
then
	#Šiauliai
	palikt_tik_reikalingus_duomenis ${miestai[12]} ${miestai[13]} ${miestai[14]} ${miestai[15]}
elif [[ "$miestas" == "Panevėžys" ]]
then
	#Panevėžys
	palikt_tik_reikalingus_duomenis ${miestai[16]} ${miestai[17]} ${miestai[18]} ${miestai[19]}
elif [[ "$miestas" == "Kaunas" ]]
then
	#Kaunas
	palikt_tik_reikalingus_duomenis ${miestai[4]} ${miestai[5]} ${miestai[6]} ${miestai[7]}
fi
rm $kelias/temp1.txt $kelias/temp2.txt $kelias/dangus2.txt $kelias/dangus1.txt

d=($(<$kelias/dangus.txt))

for ((i=1; i<15; i++))
do	
	ln -s -f "$kelias/piktogramos/${d[$i-1]}.png" "$kelias/$i.png"
done
rm $kelias/oras.txt
