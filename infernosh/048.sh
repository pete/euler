#!/dis/sh
# Find the last ten digits of the series, 1^1 + 2^2 + 3^3 + ... + 1000^1000.

# Another one that I solved but didn't have code for, and have now checked in a
# brute-force solution for, no modular exponentiation, no cleverness, 0.14s.

load mpexpr std
tendigits = ${expr 10 10 '**'}
s = 0
for i in ${expr 1 1000 seq} {
	s = ${expr $i $i '**' $s + $tendigits %}
}
echo $s
