Project Euler Offline
=====================
All Project Euler problems, with MathJax and images, as a single PDF. Additional text files are provided. Get the releases [here](https://github.com/wxv/project-euler-offline/releases).

Please report any accuracy issues or give feedback. Thanks.

Inspired by [Kyle Keen's original Local Euler](http://kmkeen.com/local-euler/2008-07-16-07-33-00.html).

Installation and Usage
----------------------
Requirements:
- PhantomJS (`apt install phantomjs`)
- Node modules system, webpage (`npm install system webpage`)
- Python 3 and BeautifulSoup, PyPDF2 (`pip install beautifulsoup4 pypdf2`)

My usage process (replace 1 and 628 with whatever range you like):

    phantomjs capture.js 1 628
    python3 combine.py 1 628
    // Optional: download solutions from https://github.com/luckytoilet/projecteuler-solutions
    cd render
    zip problems problems.pdf *.txt

