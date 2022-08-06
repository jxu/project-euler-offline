#!/bin/sh

# filters by pup tags and file extension, then curl found files
# prints files found. refactor credit: tripleee on codereview
pupcurl () {
    pup "$1" | grep "$2" |
    sed 's%^%https://projecteuler.net/%' |
    xargs -r -n1 \
        curl -sS -w "Downloading extra %{filename_effective}\n" -O
}

# loop through problem number given as script args
for i in $(seq -f "%03g" "$1" "$2"); do 
    problem_url="https://projecteuler.net/problem=$i"
    tmp_html=tmp.html

    # workaround for chromium sometimes failing (issue #3)
    # do-while loop until PDF is non-blank
    while true; do 
        # chromium print to PDF, wait for rendering 
        # https://stackoverflow.com/a/49789027
        chromium-browser --headless --disable-gpu \
            --run-all-compositor-stages-before-draw \
            --virtual-time-budget=10000 \
            --print-to-pdf-no-header \
            --print-to-pdf="$i.pdf" "$problem_url"
        
        # use 10 KB blank PDF threshold
        [ "$(stat -c "%s" "$i.pdf")" -gt 10000 ] && break
    done

    # takes html as stdin, download extra txt and gif files if available 
    curl -sS "$problem_url" > "$tmp_html"
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
    -sOutputFile=problems.pdf ./*.pdf
# create final zip
zip problems.zip problems.pdf ./*.txt ./*.gif

