rm -f minimal.html

# concat minimal HTML fragments
for i in $(seq "$1" "$2"); do
    echo "$i"
    {
        echo "<h1>Problem $i</h1>"
        curl -sS "https://projecteuler.net/minimal=$i"
        echo  # spacing for human-readability
    } >> minimal.html
done

# convert HTML fragment to Markdown
# replace pandoc's escaping of \ $ , ^ ! with non-escaped character
pandoc --to gfm --wrap preserve minimal.html | \
sed -E 's,\\([\\\$,\^!]),\1,g' > minimal.md
