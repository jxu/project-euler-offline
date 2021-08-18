#!/bin/sh
for i in $(seq -f "%03g" $1 $2); do 
    URL="https://projecteuler.net/problem=$i"
    # chromium print to PDF
    chromium-browser --headless --disable-gpu --print-to-pdf-no-header --print-to-pdf=$i.pdf $URL   
    # download extra txt and GIF files if available
    curl -s $URL | pup 'a attr{href}'  | grep '\.txt$' | sed 's/^/https:\/\/projecteuler.net\//' | xargs -r -n1 curl -O 
    curl -s $URL | pup 'img attr{src}' | grep '\.gif$' | sed 's/^/https:\/\/projecteuler.net\//' | xargs -r -n1 curl -O 
done

# remove non-animated GIFs
for i in *.gif; do 
    [ $(identify "$i" | wc -l) -le 1 ] && rm -v "$i"
done

# combine all PDFs in order
pdftk *.pdf cat output cat.pdf
# compress PDF using gs
gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -sOutputFile=problems.pdf cat.pdf
# create final zip
zip problems.zip problems.pdf *.txt *.gif

