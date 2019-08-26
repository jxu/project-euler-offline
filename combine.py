import sys
from os import sep
from PyPDF2 import PdfFileMerger

RENDER_DIR = "render"
DOWNLOAD_EXTRA_FLAG = True
SITE_MAIN = "https://projecteuler.net/"


def download_extra(url):
    """Finds if available a .txt attachment or animated .gif and downloads it
    to RENDER_DIR
    """
    # Not async for now to keep rate of requests low
    from bs4 import BeautifulSoup
    import requests
    from os.path import basename
    from PIL import Image
    from io import BytesIO

    print("Searching", url)
    content = requests.get(url).content
    soup = BeautifulSoup(content, "lxml")
    for a in soup.find_all('a', href=True):
        href = a["href"]
        if href.endswith(".txt"):
            print("Found and writing", href)
            r = requests.get(SITE_MAIN + href)
            with open(RENDER_DIR + sep + a.text, 'wb') as f:
                f.write(r.content)

    for img in soup.find_all("img"):
        img_src = img["src"]
        # Ignore spacer.gif (blank)
        if img_src.endswith(".gif") and "spacer" not in img_src:
            print("Found", img_src)
            r = requests.get(SITE_MAIN + img_src)
            # Only write animated GIFs
            if Image.open(BytesIO(r.content)).is_animated:
                print("Writing", img_src)
                with open(RENDER_DIR + sep + basename(img_src), 'wb') as f:
                    f.write(r.content) 


def main():
    problem_id_start = int(sys.argv[1])
    problem_id_end = int(sys.argv[2])

    merger = PdfFileMerger()

    for problem_id in range(problem_id_start, problem_id_end+1):
        pdf_path = RENDER_DIR + sep + str(problem_id) + ".pdf"
        merger.append(pdf_path)

    merger.write(RENDER_DIR + sep + "problems.pdf")
    print("Merged PDFs")

    if DOWNLOAD_EXTRA_FLAG:
        url_list = []
        for problem_id in range(problem_id_start, problem_id_end+1):
            url_list.append(SITE_MAIN + "problem=" + str(problem_id))

        for url in url_list:
            download_extra(url)


if __name__ == "__main__":
    main()
