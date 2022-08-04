#!/bin/sh

tmphtml=tmp.html

# takes html as stdin, download extra txt and gif files if available 
# prints links to stderr. credit: tripleee on codereview
pupcurl () {
    pup "$1" | grep "$2" |
    tee /dev/stderr |
    sed 's%^%https://projecteuler.net/%' |
    xargs -r -n1 curl -O
}

for i in $(seq -f "%03g" $1 $2); do 
    URL="https://projecteuler.net/problem=$i"
    # chromium print to PDF, wait for rendering https://stackoverflow.com/a/49789027
    chromium-browser --headless --disable-gpu --run-all-compositor-stages-before-draw --virtual-time-budget=10000 --print-to-pdf-no-header --print-to-pdf=$i.pdf $URL

    # Distill PDFs to workaround Ghostscript skipped character problem https://stackoverflow.com/questions/12806911
    gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -o ${i}_gs.pdf $i.pdf

    curl "$URL" > "$tmphtml"
    pupcurl 'a attr{href}' '\.txt$' < "$tmphtml"
    pupcurl 'img attr{src}' '\.gif$' < "$tmphtml"
done

# remove non-animated GIFs
for i in *.gif; do 
    [ $(identify "$i" | wc -l) -le 1 ] && rm -v "$i"
done

# combine all PDFs using gs
gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -sOutputFile=problems.pdf *_gs.pdf
# create final zip
zip problems.zip problems.pdf *.txt *.gif

