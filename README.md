Project Euler Offline
=====================
All Project Euler problems, with MathJax and images, as a single PDF. Additional text files and animated GIFs are provided. [Get the releases here.](https://github.com/jxu/project-euler-offline/releases)

Please report any inaccuracies or give feedback. Thanks.

Inspired by [Kyle Keen's original Local Euler](https://web.archive.org/web/20220120144108/http://kmkeen.com/local-euler/2008-07-16-07-33-00.html).


Requirements
------------

- Shell tools like curl, zip
- chromium (chrome works as well)
- [htmlq](https://github.com/mgdm/htmlq)
- ImageMagick (`identify`)
- Ghostscript (`gs`): optional to compress resulting PDF


Example Usage
-------------

    mkdir render
    cd render
    ../download.bash 1 957


History
-------

This simple download-and-combine script has been written several times as exercises in different tools and in response to Project Euler layout changes. 

1. The first version used PhantomJS as a headless browser to render the problems, then a separate python script using BeautifulSoup4 to search and download extra files (text and GIF), Pillow to check for animated GIFs, and PyPDF2 to combine the PDFs of all problems into one PDF.

2. Later I discovered Project Euler had a convenient special URL to show all problems on one page (https://projecteuler.net/show=all). This let me simply use Firefox to print a smaller PDF (in pages and size) that did not rely on the discontinued PhantomJS. The python script to download extra files remained the same.

3. In summer 2022, the convenient show all functionality disappeared, so I had to go back to downloading problems individually and combining them. This time I decided to forgo python and use only shell tools as an exercise (and to produce a smaller script). Chromium conveniently printed to PDF in headless mode, pup handled searching the HTML for extra files, Ghostscript combined the PDFs to a set print quality, and ImageMagick identified animated GIFs.

4. In summer 2024, I noticed the site had a link to display a group of 50 archived problems on the same page, with published date, solved by, and difficulty rating info. I considered the idea of just distributing PDFs for each group of 50. Unfortunately, this page is only available to logged-in users, probably for bandwidth reasons as alluded to in the News update. I could print all of them manually from Firefox, but I didn't feel like doing that, so the problems PDF is the same.

   Also, for each page there was a new button for the minimal HTML, which gave me the silly idea to create a single giant raw HTML page. Then I could use Pandoc to turn this into more readable Markdown, for those who really insisted on a text file, like the original Local Euler. I don't think anyone will actually use this, but I also don't have any evidence people used the regular PDF either. Anyhow, it shows off how flexible Pandoc's conversion abilities are.

5. In summer 2026, Project Euler changed their font and something with MathJax rendering again. I fixed some old and new rendering bugs, but the resulting PDF was 50+ MB, most of which was redundant embedded math fonts for each problem. So I went back to my minimal single HTML idea, but this time adding a little HTML to make it a proper HTML and rendering all the math in the PDF. Chromium is able to do it with about 5 GB of memory (I tried KaTeX to be more lightweight than MathJax, but a few formulas broke). The resulting PDF is under 10 MB, which is great as I've always felt the previous PDFs were always too large. The resulting render isn't identical to the original site, but pretty close. Since pup is unmaintained and harder to install, I replaced it with a similar tool, htmlq.
