#!/bin/bash
# Usage: ./download.bash 1 1000 (start and end numbers)
shopt -s nullglob

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
  body { font: 12pt/1.4 sans-serif; }
  section + section { break-before: page; }
  h2 { font-size: 18pt; margin: 0 0 .25em; color: #6b4e3d; }
  h3 { font-size: 12pt; margin: 0 0 1em; color: #666; }
  img { max-width: 100%; height: auto; }
  .center { text-align: center; }
  .monospace { font-family: monospace; overflow-wrap: anywhere; }
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
        htmlq 'h2' < fragment.html
        printf '<h3>Problem %s</h3>\n' "$i"
        htmlq '.problem_content' < fragment.html
        printf '\n</section>\n'
    } >> problems.html

    # Download extra files
    {
        htmlq --attribute href 'a[href*=".txt"]' < fragment.html
        htmlq --attribute src 'img[src*=".gif"]' < fragment.html
    } |
        sed -E 's%^%https://projecteuler.net/%; s%\?.*%%' |
        xargs -r -n1 \
            curl -sS -w "Downloading extra %{filename_effective}\n" -O
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
    (( $(identify -format '%n' "$file") == 1 )) && rm -v -- "$file"
done

# Create final zip
zip problems.zip problems.pdf ./*.txt ./*.gif
