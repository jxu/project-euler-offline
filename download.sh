#!/bin/sh

# take html as stdin, filters by pup tags and file extension
# then curl found files (print link for info)
# refactor credit: tripleee on codereview
pupcurl () {
    pup "$1" | grep "$2" |
    sed 's%^%https://projecteuler.net/%' |
    sed 's/?.*//' |
    xargs -r -n1 \
        curl -sS -w "Downloading extra %{filename_effective}\n" -O
}

# loop through problem number given as script args
for i in $(seq -f "%03g" "$1" "$2"); do 
    problem_url="https://projecteuler.net/problem=$i"
    tmp_html=tmp.html

    # chromium seems to have fixed randomly failing (issue #3)
    chromium-browser --headless  \
        --run-all-compositor-stages-before-draw \
        --virtual-time-budget=10000 \
        --no-pdf-header-footer \
        --print-to-pdf="$i.pdf" "$problem_url"


    # Distill PDFs to workaround Ghostscript skipped character problem 
    # https://stackoverflow.com/questions/12806911
    gs -q -dBATCH -dNOPAUSE -sDEVICE=pdfwrite -o "${i}_gs.pdf" "$i.pdf"

    # download html, download extra txt and gif files if available 
    curl -sS "$problem_url" > "$tmp_html"
    pupcurl 'a attr{href}' '\.txt' < "$tmp_html"
    pupcurl 'img attr{src}' '\.gif' < "$tmp_html"
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

