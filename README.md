Project Euler Offline
=====================
All Project Euler problems, with MathJax and images, as a single PDF. Additional text files are provided. [Get the releases here.](https://github.com/wxv/project-euler-offline/releases)

Please report any inaccuracies or give feedback. Thanks.

Inspired by [Kyle Keen's original Local Euler](http://kmkeen.com/local-euler/2008-07-16-07-33-00.html).

Installation and Usage
----------------------

Note: previously PhantomJS was used to download each problem individually as a PDF, and PyPDF2 was used to combine together all problems. 

Now, use "Print to File" https://projecteuler.net/show=all using Firefox (with no Headers and Footers in options). This is simpler, produces a smaller PDF, and does not rely on the discontinued PhantomJS. The python script to download extra files remains the same functionally. 

Requirements:
- Python 3 and BeautifulSoup, lxml, Pillow (`pip install beautifulsoup4 lxml pillow`)
  - BeautifulSoup and Pillow are only required for downloading extra text and images (animated GIF only).

My usage process:

    mkdir render
    # Save render/problems.pdf with Firefox as above
    python3 download_extra.py
    cd render
    zip problems.zip problems.pdf *.txt *.gif

