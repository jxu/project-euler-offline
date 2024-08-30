rm -f minimal.html

# concat minimal HTML fragments
for i in {1..903}; do
    echo $i
    echo "<h1>Problem $i</h1>" >> minimal.html
    curl -sS https://projecteuler.net/minimal=$i >> minimal.html
    echo >> minimal.html  # spacing for human-readability
done

# convert HTML fragment to Markdown
# replace pandoc's escaping of \ $ , ^ ! with non-escaped character
pandoc --to gfm --wrap preserve minimal.html | \
sed -E 's,\\([\\\$,\^!]),\1,g' > minimal.md
