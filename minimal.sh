rm -f minimal.html
for i in {1..903}; do
    echo $i
    echo "<h1>Problem $i</h1>" >> minimal.html
    curl -sS https://projecteuler.net/minimal=$i >> minimal.html
    echo >> minimal.html
done
