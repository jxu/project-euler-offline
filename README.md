Project Euler Offline
=====================
All Project Euler problems, with MathJax and images, as a single PDF. Additional text files are provided. [Get the releases here.](https://github.com/wxv/project-euler-offline/releases)

Please report any inaccuracies or give feedback. Thanks.

Inspired by [Kyle Keen's original Local Euler](http://kmkeen.com/local-euler/2008-07-16-07-33-00.html).


Requirements
------------

- Shell tools like curl, zip
- chromium-browser
- [pup](https://github.com/ericchiang/pup)
- pdftk
- ImageMagick
- GhostScript


Example Usage
-------------

    mkdir render
    cd render
    ../download.sh 1 761
    

History
-------

This simple download-and-combine script has been written several times as exercises in different tools and in response to Project Euler layout changes. 

1. The first version used PhantomJS as a headless browser to render the problems, then a separate python script using BeautifulSoup4 to search and download extra files (text and GIF), Pillow to check for animated GIFs, and PyPDF2 to combine the PDFs of all problems into one PDF.
2. Later I discovered Project Euler had a convenient special URL to show all problems on one page (https://projecteuler.net/show=all). This let me simply use Firefox to print a smaller PDF (in pages and size) that did not rely on the discontinued PhantomJS. The python script to download extra files remained the same.
3. Sometime after summer 2020 the convenient URL functionality disappeared, so I had to go back to downloading problems individually and combining them. This time I decided to forgo python and use only shell tools as an exercise (and to produce a smaller script). Chromium in headless mode had a convenient option to print to PDF, pup handled searching the HTML for extra files, pdftk combined the PDFs, and ImageMagick identified animated GIFs. Running the final PDF through GhostScript was able to halve the PDF size.

