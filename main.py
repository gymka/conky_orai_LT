#!/usr/bin/python

import re
import urllib.request
user_agent = 'Mozilla/5.0 (X11; Linux x86_64; rv:27.0) Gecko/20100101 Firefox/27.0'
headers = { 'User-Agent' : user_agent }

#url="http://www.yr.no/place/Lithuania/Other/Kaunas~598316/"
url="http://www.yr.no/place/Lithuania/Other/Kaunas~598316/long.html"
response = urllib.request.urlopen(urllib.request.Request(url, headers={'User-Agent': user_agent})).read().decode("utf-8")
dienos=re.findall("<th scope=\"col\".*?>(.*?)<span>.*?</span>.*</th>",response,re.IGNORECASE)
debesys_diena=re.findall("<img alt=\".*For the period.*(11:00–17:00|14:00–20:00)\" src=\"http://symbol.yr.no/grafikk/sym/b38/(.*).png\" width=\"38\" height=\"38",response,re.IGNORECASE)
debesys_naktis=re.findall("<img alt=\".*For the period.*(23:00–05:00|02:00–08:00)\" src=\"http://symbol.yr.no/grafikk/sym/b38/(.*).png\" width=\"38\" height=\"38",response,re.IGNORECASE)
debesys=re.findall("<img src=\"http://symbol.yr.no/grafikk/sym/b48/(.*)\.png\" width=\"48\" height=\"48\"",response,re.IGNORECASE)
nakties_temp=re.findall("<td class=\"temperature .*\" title=\"Temperature:.*Feels like.*For the period: (23:00|02:00)\">(.*)°</td>",response,re.IGNORECASE)
dienos_temp=re.findall("<td class=\"temperature .*\" title=\"Temperature:.*Feels like.*For the period: (11:00|14:00)\">(.*)°</td>",response,re.IGNORECASE)

print(debesys_naktis)




