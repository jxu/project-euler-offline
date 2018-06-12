import sys
from os import sep
from PyPDF2 import PdfFileMerger



render_dir = "render"
download_extra_flag = True

def download_extra(url):
    '''Tries to find a .txt attachment or .gif and download it to render_dir.'''
    # TODO async request
    from bs4 import BeautifulSoup
    import requests
    from os.path import basename
    from PIL import Image
    from io import BytesIO

    site_main = "http://projecteuler.net/"

    print("Searching", url)
    content = requests.get(url).content
    soup = BeautifulSoup(content, "lxml")
    for a in soup.find_all('a', href=True):
        if a["href"].endswith(".txt"):
            print("Found", a["href"])
            r = requests.get(site_main + a["href"])
            with open(render_dir + sep + a.text, 'wb') as f:
                f.write(r.content)

    for img in soup.find_all("img"):
        img_src = img["src"]
        # Ignore spacer.gif (blank)
        if img_src.endswith(".gif") and "spacer" not in img_src:
            print("Found", img_src)
            r = requests.get(site_main + img_src)
            # Only write animated GIFs
            if Image.open(BytesIO(r.content)).is_animated:
                print("Writing", img_src)
                with open(render_dir + sep + basename(img_src), 'wb') as f:
                    f.write(r.content) 


def main():
    problem_id_start = int(sys.argv[1])
    problem_id_end = int(sys.argv[2])

    merger = PdfFileMerger()

    for problem_id in range(problem_id_start, problem_id_end+1):
        pdf_path = render_dir + sep + str(problem_id) + ".pdf"
        merger.append(pdf_path)

    merger.write(render_dir + sep + "problems.pdf")
    print("Merged PDFs")


    if download_extra_flag:
        url_list = []
        for problem_id in range(problem_id_start, problem_id_end+1):
            url_list.append("https://projecteuler.net/problem=" + str(problem_id))

        for url in url_list:
            download_extra(url)


if __name__ == "__main__":
    main()

