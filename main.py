#!/usr/bin/python

import re
import subprocess
import os
from datetime import *

#======Duomenų parsiuntimas=======
#tiek requests, tiek urllib moduliai pastoviai po kažkiek bandymų pradeda rašyt jog negali resolvint adreso, nors naršyklėj viskas gerai. Todėl naudoju linux'ų curl, žymiai patikimesnis
orai_html_long = subprocess.check_output(["curl", "http://www.yr.no/place/Lithuania/Kaunas/Kaunas/long.html"]).decode("utf-8")
orai_html_short = subprocess.check_output(["curl", "http://www.weather.com/weather/today/Kaunas+LHXX0002:1:LH"]).decode("utf-8")


#=======Duomenų apdorojimas=========
class orai():
	#grazina savaitės dienas. dienos[0])
	dienos=re.findall("<th scope=\"col\".*?>(.*?)<span>.*?</span>.*</th>",orai_html_long,re.IGNORECASE)

	#gražina numerį paveiksliuko su debesuotumu dieną.dangus_diena[0][1])
	dangus_diena=re.findall("<img alt=\".*For the period.*(11:00–17:00|14:00–20:00)\" src=\"http://symbol.yr.no/grafikk/sym/b38/(.*.png)\" width=\"38\" height=\"38",orai_html_long,re.IGNORECASE)

	#gražina numerį paveiksliuko su debesuotumu naktį. orai_long.dangus_naktis()[0][1])
	dangus_nakti=re.findall("<img alt=\".*For the period.*(23:00–05:00|02:00–08:00)\" src=\"http://symbol.yr.no/grafikk/sym/b38/(.*.png)\" width=\"38\" height=\"38",orai_html_long,re.IGNORECASE)
		
	#temperatūros naktį. orai_long.temp_nakti()[0][1])
	temp_nakti=re.findall("<td class=\"temperature .*\" title=\"Temperature:.*Feels like.*For the period: (23:00|02:00)\">(.*)°</td>",orai_html_long,re.IGNORECASE)

	#temperatūros dieną. orai_long.temp_diena()[0][1])
	temp_diena=re.findall("<td class=\"temperature .*\" title=\"Temperature:.*Feels like.*For the period: (11:00|14:00)\">(.*)°</td>",orai_html_long,re.IGNORECASE)

	#grąžina masyvą su 3 elementais
	vejas_diena=re.findall("<td class=\"txt-left\" title=\"(.*), (.*m/s) from (.*)\.  For the period: (11:00|14:00)\">",orai_html_long,re.IGNORECASE)

	#grąžina masyvą su 3 elementais
	vejas_naktis=re.findall("<td class=\"txt-left\" title=\"(.*), (.*m/s) from (.*)\.  For the period: (23:00|02:00)\">",orai_html_long,re.IGNORECASE)

class orai_day():
	orai_short=re.split("<h2>Right Now</h2>",orai_html_short)
	orai_short=orai_short[1].split("<div class=\"wx-timepart-title\">Tonight</div>")
	atnaujinta=re.findall("Updated: <span class=\"wx-value\" itemprop=\"last-updated\">(.*), (.*) Local Time</span>",orai_short[0],re.IGNORECASE)
	atnaujinta=atnaujinta[0][1]
	atnaujinta=datetime.strptime(atnaujinta, '%I:%M%p')
	atnaujinta=str(atnaujinta)[11:16]
	piktograma=re.findall("<img class=\"wx-weather-icon\" src=\"http://s\.imwx\.com/.*/(.*)\.png\".*\">",orai_short[0],re.IGNORECASE)
	temperatura=re.findall("<span class=\"wx-value\" itemprop=\"temperature-fahrenheit\">(.*)</span>",orai_short[0],re.IGNORECASE)
	temperatura=int(temperatura[0])-32
	temperatura=temperatura*5
	temperatura=temperatura/9
	vejas_day=re.findall("div class=\"wx-dir-arrow wind-dir-(.*)\"></div>",orai_short[0],re.IGNORECASE)
	vejas_stiprumas=re.findall("<span class=\"wx-temp\">(.*)</span><span class=\"wx-cc-wind-speed-mph\">mph</span></div>",orai_short[0],re.IGNORECASE)	
	vejas_stiprumas=round(int(vejas_stiprumas[0])*1.609344)	

def isverst_veja(vejas):
	veju_array={"south":("pietų","\u2191"),"north":("šiaurės","\u2193"), "east":("rytų","\u2190"), "west":("vakarų","\u2192"), "northeast":("šiaurės rytų","\u2199"), "northwest":("šiaurės vakarų","\u2198"), "southeast":("pietryčių","\u2196"), "southwest":("pietvakarių","\u2197"), "north-northeast":("šiaurės šiaurės rytų","\u2199"), "south-southwest":("pietų pietryčių","\u2197"), "west-southwest":("vakarų pietvakarių","\u2197"), "south-southeast":("pietų pietryčių","\u2196"), "east-southeast":("rytų pietryčių","\u2196"), "east-northeast":("rytų šiaurės rytų","\u2199"), "north-northwest":("rytų šiaurės vakarų","\u2198"), "west-northwest":("vakarų šiaurės vakarų","\u2198"),"S":"Pietų","N":"Šiaurės","E":"Rytų","W":"Vakarų","NE":"Šiaurės rytų","NW":"Šiaurės vakarų","SE":"Pietryčių","SW":"Pietvakarių","NNE":"Šiaurės šiaurės rytų","SSW":"Pietų pietvakarių","WSW":"Vakarų pietvakarių","SSE":"Pietų pietryčių","ESE":"Rytų pietryčių","ENE":"Rytų šiaurės rytų","NNW":"Šiaurės šiaurės vakarų","WNW":"Vakarų šiaurės vakarų"}
	return veju_array[vejas]
isverst_diena={"Monday":"Pirmadienis","Tuesday":"Antradienis","Wednesday":"Trečiadienis","Thursday":"Ketvirtadienis","Friday":"Penktadienis","Saturday":"Šeštadienis","Sunday":"Sekmadienis"}



#surašom duomenis į failą
orai()

failas=open("orai.txt","w")
failas.write("="*10+"Prognozė"+"="*10+"\n")
for i in range(0,9): #TODO jei pasikeis kodas ir ras mažiau elementų, bus bėda.
	failas.write(isverst_diena[orai.dienos[i]]+"\n")
	vejasx=orai.vejas_diena[i][2]
	failas.write(isverst_veja(vejasx)[0]+"\n")
	failas.write(isverst_veja(vejasx)[1]+"\n")
	os.system('ln -s -f ${PWD}/paveiksliukai/'+orai.dangus_diena[i][1]+' ./'+str(i)+'.png')
	os.system('ln -s -f ${PWD}/paveiksliukai/'+orai.dangus_nakti[i][1]+' ./'+str(i)+'N.png')
	failas.write(orai.temp_nakti[i][1]+"\n")
	failas.write(orai.temp_diena[i][1]+"\n")
	failas.write("-"*20+"\n")
failas.write("="*10+"Dienos prognozė"+"="*10+"\n")
os.system('ln -s -f ${PWD}/paveiksliukai/weathercom/'+orai_day.piktograma[0]+'.png ./dabar.png')
failas.write(str(round(orai_day.temperatura))+"\n")
failas.write(isverst_veja(orai_day.vejas_day[0])+"\n")
failas.write(str(orai_day.vejas_stiprumas)+"\n")
failas.write(str(orai_day.atnaujinta)+"\n")
failas.write("-"*20+"\n")
failas.close()

