#!/bin/sh

tmp_html=tmp.html
problem_url="https://projecteuler.net/problem=$i"

# takes html as stdin, download extra txt and gif files if available 
# prints links to stderr. credit: tripleee on codereview
pupcurl () {
    pup "$1" | grep "$2" |
    tee /dev/stderr |
    sed 's%^%https://projecteuler.net/%' |
    xargs -r -n1 curl -O
}

for i in $(seq -f "%03g" "$1" "$2"); do 
    # chromium print to PDF, wait for rendering 
    # https://stackoverflow.com/a/49789027
    chromium-browser --headless --disable-gpu \
        --run-all-compositor-stages-before-draw \
        --virtual-time-budget=10000 \
        --print-to-pdf-no-header \
        --print-to-pdf="$i.pdf" "$problem_url"

    # Distill PDFs to workaround Ghostscript skipped character problem 
    # https://stackoverflow.com/questions/12806911
    gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -o "${i}_gs.pdf" "$i.pdf"

    curl -s "$problem_url" > "$tmp_html"
    pupcurl 'a attr{href}' '\.txt$' < "$tmp_html"
    pupcurl 'img attr{src}' '\.gif$' < "$tmp_html"
done

# remove non-animated GIFs
for i in *.gif; do 
    [ "$(identify "$i" | wc -l)" -le 1 ] && rm -v "$i"
done

# combine all PDFs using gs
gs -dBATCH -dNOPAUSE -sDEVICE=pdfwrite \
    -dPDFSETTINGS=/ebook \
    -sOutputFile=problems.pdf ./*_gs.pdf
# create final zip
zip problems.zip problems.pdf ./*.txt ./*.gif

