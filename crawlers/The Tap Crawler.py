import requests
from bs4 import BeautifulSoup

pageLink= "http://www.thetapbeerbar.com/events/"

page_response = requests.get(pageLink, timeout=5)

page_content = BeautifulSoup(page_response.content, "html.parser")


events = page_content.find_all("h3", class_="tribe-events-list-event-title")

artists = list(events)

for artist in artists:
    print(artist.get_text())



details=  page_content.find_all("div", class_="author")


eventDetails= list(details)

for event in eventDetails:
    print(event.get_text())
