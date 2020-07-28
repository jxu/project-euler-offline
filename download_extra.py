import sys
from os import sep
# Not async for now to keep rate of requests low
from bs4 import BeautifulSoup
import requests
from os.path import basename
from PIL import Image
from io import BytesIO


RENDER_DIR = "render"
SITE_MAIN = "https://projecteuler.net/"


def download_extra(url):
    """Finds if available a .txt attachment or animated .gif and downloads it
    to RENDER_DIR
    """
    content = requests.get(url).content
    soup = BeautifulSoup(content, "lxml")
    for a in soup.find_all('a', href=True):
        href = a["href"]
        if href.endswith(".txt"):
            print("Writing", href)
            r = requests.get(SITE_MAIN + href)
            with open(RENDER_DIR + sep + basename(href), 'wb') as f:
                f.write(r.content)

    for img in soup.find_all("img"):
        img_src = img["src"]

        # Skip non-GIFs and spacer.gif
        if not img_src.endswith(".gif") or img_src.endswith("spacer.gif"): 
            continue

        r = requests.get(SITE_MAIN + img_src)
        # Only write animated GIFs
        if Image.open(BytesIO(r.content)).is_animated:
            print("Writing", img_src)
            with open(RENDER_DIR + sep + basename(img_src), 'wb') as f:
                f.write(r.content) 


def main():    
    download_extra("https://projecteuler.net/show=all")


if __name__ == "__main__":
    main()
