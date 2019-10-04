import requests
from bs4 import BeautifulSoup
import mysql.connector



pageLink= "https://kilroyskirkwood.com/specials/"

page_response = requests.get(pageLink, timeout=5)

page_content = BeautifulSoup(page_response.content, "html.parser")


specials = page_content.find_all("strong")

days = specials[0::2]

allDays= [day.get_text().strip().encode('ascii', errors='ignore').decode() for day in days]
#print(allDays)


#print(len(specials))
findDeals = page_content.find_all(style="margin-left: 15px;")
#print(len(findDeals))

deals= [deal.get_text().strip().encode('utf-8-sig', errors='ignore').decode() for deal in findDeals]
listedDeals = [i.split('\n') for i in deals] 
#print(len(deals))


#
mydb = mysql.connector.connect(user='i494f18_team68',
                               password ='my+sql=i494f18_team68',
                               host='db.sice.indiana.edu',
                               database='i494f18_team68',)
mycursor = mydb.cursor()
#


for days in range(len(allDays)):
    for deals in range(len(listedDeals[days])):
        sql = ("INSERT INTO barSpecials"
           "(barID, day, specials)"
           "VALUES (%s, %s, %s)")
        values = (7, allDays[days], listedDeals[days][deals])

        mycursor.execute(sql, values)
    print("inserted")
mydb.commit()    
print(mycursor.rowcount, "record inserted.")

      


