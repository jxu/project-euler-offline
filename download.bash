#!/bin/bash
# Usage: ./download.bash 1 1000 (start and end numbers)
shopt -s nullglob

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

# Minimal HTML page template
cat > problems.html <<'EOF'
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<base href="https://projecteuler.net/">
<title>Project Euler Problems</title>
<style>
  @page { margin: 16mm; }
  body { font: 11pt/1.4 sans-serif; }
  section + section { break-before: page; }
  h1 { font-size: 12pt; margin: 0 0 1em; color: #666; }
  h2 { font-size: 18pt; margin: 0 0 .25em; color: #6b4e3d; }
  img { max-width: 100%; height: auto; }
  .center { text-align: center; }
  .monospace { font-family: monospace; }
  .red { color: #c00; }
  .green { color: #080; }
  .tooltiptext { display: none; }
</style>
<script>
window.MathJax = { tex: { inlineMath: [['$', '$']] } };
</script>
<script defer src="https://cdn.jsdelivr.net/npm/mathjax@4/tex-mml-chtml.js"></script>
</head>
<body>
EOF

# Download each problem page once, extract its title and problem body for PDF
for i in $(seq "$1" "$2"); do
    echo "Downloading problem $i"
    curl -fsS "https://projecteuler.net/problem=$i" > fragment.html

    {
        printf '<section class="problem" id="problem-%s">\n' "$i"
        pup 'h2' < fragment.html
        printf '<h1>Problem %s</h1>\n' "$i"
        pup '.problem_content' < fragment.html
        printf '\n</section>\n'
    } >> problems.html

    # Download extra files
    pupcurl 'a attr{href}' '\.txt' < fragment.html
    pupcurl 'img attr{src}' '\.gif' < fragment.html
done

printf '</body>\n</html>\n' >> problems.html

chromium --headless \
    --run-all-compositor-stages-before-draw \
    --virtual-time-budget=60000 \
    --no-pdf-header-footer \
    --print-to-pdf="$PWD/problems-uncompressed.pdf" "file://$PWD/problems.html"

# Compress Chromium's PDF output with Ghostscript
gs -q -dBATCH -dNOPAUSE -sDEVICE=pdfwrite \
    -dPDFSETTINGS=/printer \
    -dDetectDuplicateImages=true \
    -dCompressFonts=true \
    -dSubsetFonts=true \
    -sOutputFile=problems.pdf problems-uncompressed.pdf

# Retain animated GIFs only
for file in *.gif; do
    if (( $(identify "$file" | wc -l) <= 1 )); then
        rm -v -- "$file"
    fi
done

# Create final zip
zip problems.zip problems.pdf ./*.txt ./*.gif
