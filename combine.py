from bs4 import BeautifulSoup
import requests
import sys
from os import sep
from PyPDF2 import PdfFileMerger


render_dir = "render"
download_txt_flag = True

def download_txt(url):
    '''Tries to find a .txt attachment and download it to render_dir.'''
    print("Searching", url)
    content = requests.get(url).content
    soup = BeautifulSoup(content, "lxml")
    for a in soup.find_all('a', href=True):
        if a["href"].endswith(".txt"):
            print("Found", a["href"])
            r = requests.get("http://projecteuler.net/" + a["href"])
            with open(render_dir + sep + a.text, 'wb') as f:
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


    if download_txt_flag:
        url_list = []
        for problem_id in range(problem_id_start, problem_id_end+1):
            url_list.append("https://projecteuler.net/problem=" + str(problem_id))

        for url in url_list:
            download_txt(url)


if __name__ == "__main__":
    main()

