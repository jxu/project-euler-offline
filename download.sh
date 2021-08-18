#!/bin/sh
for i in $(seq -f "%03g" $1 $2); do 
    URL="https://projecteuler.net/problem=$i"
    chromium-browser --headless --disable-gpu --print-to-pdf-no-header --print-to-pdf=$i.pdf $URL   
    curl -s $URL | pup 'a attr{href}'  | grep '\.txt$' | sed 's/^/https:\/\/projecteuler.net\//' | xargs -r curl -O 
    curl -s $URL | pup 'img attr{src}' | grep '\.gif$' | sed 's/^/https:\/\/projecteuler.net\//' | xargs -r curl -O 
done

