import requests
from bs4 import BeautifulSoup

pageLink= "https://www.thebluebird.ws/"

page_response = requests.get(pageLink, timeout=5)

page_content = BeautifulSoup(page_response.content, "html.parser")

events = page_content.find_all(True,{"class":["dates","headliners summary","times","age-restiction","ticket-price"]})

calendar= list(events)

for item in calendar:
    print(item.get_text())

