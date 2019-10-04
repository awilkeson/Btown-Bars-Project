import requests
from bs4 import BeautifulSoup

pageLink= "https://kilroyskirkwood.com/specials/"

page_response = requests.get(pageLink, timeout=5)

page_content = BeautifulSoup(page_response.content, "html.parser")


specials = page_content.find_all("strong")

days = specials[1::2]

for day in days:
    print(day.get_text())


findDeals = page_content.find_all(style="margin-left: 15px;")

deals= [deal for deal in findDeals]

for entry in deals:
    print(entry.get_text())

    
        

o
