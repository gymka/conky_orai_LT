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


typeset -A dangus
typeset -A vejas
typeset -A uv
dangus["tornado"]="tornadas"
dangus["tropical storm"]="tropinė audra"
dangus["hurricane"]="uraganas"
dangus["severe thunderstorms"]="galima stipri perkūnija"
dangus["thunderstorms"]="galima perkūnija"
dangus["mixed rain and snow"]="šlapdriba"
dangus["mixed rain and sleet"]="šlapdriba"
dangus["mixed snow and sleet"]="šlapdriba"
dangus["freezing drizzle"]="šalta dulksna"
dangus["drizzle"]="dulksna"
dangus["freezing rain"]="šaltas lietus"
dangus["showers"]="liūtys"
dangus["snow flurries"]="silpnai sninga"
dangus["light snow showers"]="protarpiais lengvai sninga"
dangus["blowing snow"]="pusto"
dangus["snow"]="sninga"
dangus["hail"]="kruša"
dangus["sleet"]="šlapdriba"
dangus["dust"]="pustomos dulkės"
dangus["foggy"]="ūkanota"
dangus["haze"]="rūkas"
dangus["fog"]="rūkas"
dangus["mist"]="rūkas"
dangus["smoky"]="smogas"
dangus["smoke"]="smogas"
dangus["blustery"]="blustery"
dangus["windy"]="vėjuota"
dangus["cold"]="šalta"
dangus["cloudy"]="debesuota"
dangus["mostly cloudy"]="šiek tiek debesuota"
dangus["partly cloudy"]="vietomis debesuota"
dangus["clear"]="giedra"
dangus["sunny"]="saulėta"
dangus["fair"]="giedra"
dangus["mixed rain and hail"]="lietus ir kruša"
dangus["hot"]="karšta"
dangus["isolated thunderstorms"]="vietomis galima perkūnija"
dangus["scattered thunderstorms"]="padrikos perkūnijos"
dangus["scattered showers"]="padrikos liūtys"
dangus["heavy snow"]="smarkiai sninga"
dangus["scattered snow showers"]="silpnas lietus su sniegu"
dangus["thundershowers"]="galimos liūtys su perkūnija"
dangus["snow showers"]="pūgos"
dangus["isolated thundershowers"]="vietomis liūtys"
dangus["not available"]="neprieinama"
dangus["light rain shower"]="protarpiais lengvas lietus"
dangus["light rain"]="protarpiais lietus"
dangus["light snow"]="lengvai sninga"
dangus["light drizzle"]="lengva dulksna"
dangus["drifting snow"]="nešioja sniegą"
dangus["rain and snow"]="šlapdriba"
dangus["???"]="???"

vejas["s"]="P"
vejas["n"]="Š"
vejas["e"]="R"
vejas["w"]="V"
vejas["ne"]="ŠR"
vejas["nw"]="ŠV"
vejas["se"]="PR"
vejas["sw"]="PV"
vejas["nne"]="ŠŠR"
vejas["ssw"]="PPV"
vejas["wsw"]="VPV"
vejas["sse"]="PPR"
vejas["ese"]="RPT"
vejas["ene"]="RŠR"
vejas["nnw"]="ŠŠV"
vejas["wnw"]="VŠV"
vejas["???"]="???"

uv["0 - low"]="0 - žemas"
uv["1 - low"]="1 - žemas"
uv["2 - low"]="2 - žemas"
uv["3 - moderate"]="3 - vidutinis"
uv["4 - moderate"]="4 - vidutinis"
uv["5 - moderate"]="5 - vidutinis"
uv["6 - high"]="6 - aukštas"
uv["7 - high"]="7 - aukštas"
uv["8 - very high"]="8 - labai aukštas"
uv["9 - very high"]="9 - labai aukštas"
uv["10 - very high"]="10 - labai aukštas"
uv["10+ - high"]="10+ - ekstremalus"
uv["???"]="???"


#isverst dangaus ir vėjo būseną
vejas_org=$(tr '[:upper:]' '[:lower:]' < $kelias/oras_db_data.txt)
#vejas_org2=$(tr '[:upper:]' '[:lower:]' < $kelias/oru_prognoze.txt)
dangus_org=$(sed -n '3p' $kelias/oras_db_data.txt|sed 's/^$/???/')
uv_org=$(sed -n '9p' $kelias/oras_db_data.txt|sed 's/^$/???/')


if [[ -z ${vejas[$vejas_org]} ]]; #jei nėra tokios reikšmės tai arba jau išversta arba gauta nežinoma būsena, todėl paliekam originalią.
	then vejas2=$vejas_org
		echo "Vėjas: $vejas_org">>$kelias/neisversta.txt 
		sort -u $kelias/neisversta.txt -o $kelias/neisversta.txt
	else vejas2=${vejas[$vejas_org]}
fi 


if [[ -z ${dangus[$dangus_org]} ]]; #jei nėra tokios reikšmės tai arba jau išversta arba gauta nežinoma būsena, todėl paliekam originalią.
	then dangus2=$dangus_org 
		echo "Dangus: $dangus_org">>$kelias/neisversta.txt 
		sort -u $kelias/neisversta.txt -o $kelias/neisversta.txt
	else dangus2=${dangus[$dangus_org]}
fi 

if [[ -z ${uv[$uv_org]} ]]; #jei nėra tokios reikšmės tai arba jau išversta arba gauta nežinoma būsena, todėl paliekam originalią.
	then uv2=$uv_org
	else uv2=${uv[$uv_org]}
fi 

sed -i "3s/.*/$dangus2/" $kelias/oras_db_data.txt
sed -i "4s/.*/$vejas2/" $kelias/oras_db_data.txt
sed -i "9s/.*/$uv2/" $kelias/oras_db_data.txt

if [[ -z ${vejas[$vejas_org2]} ]]; #jei nėra tokios reikšmės tai arba jau išversta arba gauta nežinoma būsena, todėl paliekam originalią.
	then vejas2=${vejas_org2}
		echo "Vėjas: $vejas_org">>$kelias/neisversta.txt 
		sort -u $kelias/neisversta.txt -o $kelias/neisversta.txt
	else vejas2=${vejas[$vejas_org2]}
fi 

for (( i=0; i < 5; i++ ))
	do 
		eil_nr=$(echo -e "16+${i}"|bc)
		sed -i "${eil_nr}s/.*/$vejas2/" $kelias/oru_prognoze.txt
done
