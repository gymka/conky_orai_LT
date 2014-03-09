#!/usr/bin/python

import re
import urllib.request
import os
import random

#======Duomenų parsiuntimas=======
url="http://www.yr.no/place/Lithuania/Kaunas/Kaunas/long.html"
url2="http://www.yr.no/place/Lithuania/Kaunas/Kaunas/"
url3="http://www.akmc.lt"
klaida=False
orai_html_long=""

try:
	orai_html_long = urllib.request.urlopen(urllib.request.Request(url, headers={"User-Agent" : "Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0", "Accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Accept-Language" : "lt,en;q=0.7,ru;q=0.3", "DNT" : "1", "Connection" : "keep-alive"})).read().decode("utf-8")
except:
	klaida=True

try:
	orai_html_short = urllib.request.urlopen(urllib.request.Request(url2, headers={"User-Agent" : "Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0", "Accept" : "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8", "Accept-Language" : "lt,en;q=0.7,ru;q=0.3", "DNT" : "1", "Connection" : "keep-alive"})).read().decode("utf-8")
	orai_short=re.split("<td> 11:00–17:00|14:00–20:00</td>",orai_html_short)
	orai_short=orai_short[1].split("</tr>")
except:
	klaida=True
klaidos_rez=("??","??","??","??","??","??","??","??","??")

#=======Duomenų apdorojimas=========
class orai():
	def dienos(source):
		#grazina savaitės dienas. orai_long.dienos()[0])
		if klaida is not True:
			return re.findall("<th scope=\"col\".*?>(.*?)<span>.*?</span>.*</th>",source,re.IGNORECASE)
		else:
			return klaidos_rez
			
	def dangus_diena(source):
		#gražina numerį paveiksliuko su debesuotumu dieną. orai_long.dangus_diena()[0][1])
		if klaida is not True:
			return re.findall("<img alt=\".*For the period.*(11:00–17:00|14:00–20:00)\" src=\"http://symbol.yr.no/grafikk/sym/b38/(.*.png)\" width=\"38\" height=\"38",source,re.IGNORECASE)
		else:
			return klaidos_rez
			
	def dangus_nakti(source):
		#gražina numerį paveiksliuko su debesuotumu naktį. orai_long.dangus_naktis()[0][1])
		if klaida is not True:
			return re.findall("<img alt=\".*For the period.*(23:00–05:00|02:00–08:00)\" src=\"http://symbol.yr.no/grafikk/sym/b38/(.*.png)\" width=\"38\" height=\"38",source,re.IGNORECASE)
		else:
			return klaidos_rez
			
	def temp_nakti(source):
		#temperatūros naktį. orai_long.temp_nakti()[0][1])
		if klaida is not True:
			return re.findall("<td class=\"temperature .*\" title=\"Temperature:.*Feels like.*For the period: (23:00|02:00)\">(.*)°</td>",source,re.IGNORECASE)
		else:
			return klaidos_rez
			
	def temp_diena(source):
		#temperatūros dieną. orai_long.temp_diena()[0][1])
		if klaida is not True:
			return re.findall("<td class=\"temperature .*\" title=\"Temperature:.*Feels like.*For the period: (11:00|14:00)\">(.*)°</td>",source,re.IGNORECASE)
		else:
			return klaidos_rez
			
	def vejas_diena(source):
		#grąžina masyvą su 3 elementais
		if klaida is not True:
			return re.findall("<td class=\"txt-left\" title=\"(.*), (.*m/s) from (.*)\.  For the period: (11:00|14:00)\">",source,re.IGNORECASE)
		else:
			return klaidos_rez
			
	def vejas_naktis(source):
		#grąžina masyvą su 3 elementais
		if klaida is not True:
			return re.findall("<td class=\"txt-left\" title=\"(.*), (.*m/s) from (.*)\.  For the period: (23:00|02:00)\">",source,re.IGNORECASE)
		else:
			return klaidos_rez

class orai_day():
	def dangus():
		if klaida is not True:
			return re.findall("<img src=\"http://symbol\.yr\.no/grafikk/sym/b38/(.*\.png)\"",orai_short[0],re.IGNORECASE)[0]
		else:
			return klaidos_rez
	def temp():
		if klaida is not True:
			return re.findall("<td class=\"temperature .*\" title=\"Temperature:.*For the period: (14:00|11:00)\">(.*°)</td>",orai_short[0],re.IGNORECASE)[0][1]
		else:
			return klaidos_rez
	def krituliai():
		if klaida is not True:
			return re.findall("td title=\"Precipitation:.*For the period: (11:00–17:00|14:00–20:00).*>(.*mm)</td>",orai_short[0],re.IGNORECASE)[0][1]
		else:
			return klaidos_rez
	def vejas():
		#grąžina masyvą su 3 elementais
		if klaida is not True:
			return re.findall("class=\"wind\" alt=\"(.*), (.*m/s) from (.*)\" ",orai_short[0],re.IGNORECASE)[0]
		else:
			return klaidos_rez			
def isverst_veja(vejas):
	veju_array={"south":("pietų","\u2191"),"north":("šiaurės","\u2193"), "east":("rytų","\u2190"), "west":("vakarų","\u2192"), "northeast":("šiaurės rytų","\u2199"), "northwest":("šiaurės vakarų","\u2198"), "southeast":("pietryčių","\u2196"), "southwest":("pietvakarių","\u2197"), "north-northeast":("šiaurės šiaurės rytų","\u2199"), "south-southwest":("pietų pietryčių","\u2197"), "west-southwest":("vakarų pietvakarių","\u2197"), "south-southeast":("pietų pietryčių","\u2196"), "east-southeast":("rytų pietryčių","\u2196"), "east-northeast":("rytų šiaurės rytų","\u2199"), "north-northwest":("rytų šiaurės vakarų","\u2198"), "west-northwest":("vakarų šiaurės vakarų","\u2198")}
	return veju_array[vejas]
isverst_diena={"Monday":"Pirmadienis","Tuesday":"Antradienis","Wednesday":"Trečiadienis","Thursday":"Ketvirtadienis","Friday":"Penktadienis","Saturday":"Šeštadienis","Sunday":"Sekmadienis"}



#surašom duomenis į failą
if klaida is not True:
	failas=open("orai.txt","w")
	failas.write("="*10+"Prognozė"+"="*10+"\n")
	for i in range(0,9): #TODO jei pasikeis kodas ir ras mažiau elementų, bus bėda.
		failas.write(isverst_diena[orai.dienos(orai_html_long)[i]]+"\n")
		vejasx=orai.vejas_diena(orai_html_long)[i][2]
		failas.write(isverst_veja(vejasx)[0]+"\n")
		failas.write(isverst_veja(vejasx)[1]+"\n")
		os.system('ln -s -f ${PWD}/paveiksliukai/'+orai.dangus_diena(orai_html_long)[i][1]+' ./'+str(i)+'.png')
		os.system('ln -s -f ${PWD}/paveiksliukai/'+orai.dangus_nakti(orai_html_long)[i][1]+' ./'+str(i)+'N.png')
		failas.write(orai.temp_nakti(orai_html_long)[i][1]+"\n")
		failas.write(orai.temp_diena(orai_html_long)[i][1]+"\n")
		failas.write("-"*20+"\n")
	failas.write("="*10+"Dienos prognozė"+"="*10+"\n")
	os.system('ln -s -f ${PWD}/paveiksliukai/'+orai_day.dangus()+' ./dabar.png')
	failas.write(orai_day.temp()+"\n")
	failas.write(orai_day.krituliai()+"\n")
	failas.write(orai_day.vejas()[1]+"\n")
	failas.write(isverst_veja(orai_day.vejas()[2])[0]+"\n")
	failas.write(isverst_veja(orai_day.vejas()[2])[1]+"\n")
	failas.write("-"*20+"\n")
	failas.close()

