#!/dis/sh
# How many distinct terms are in the sequence generated by a^b for 2 <= a <= 100
# and 2 <= b <= 100?
#
# I had no code for this one.  I suspect I just did it in a REPL somewhere.
# Anyway, I solved it before I knew anything about Inferno, so I can't have done
# it in the Inferno shell.  Here's a solution, not a great one, 1.04s.

load mpexpr std echo

# This is the brute force version with giant numbers.  The slightly smarter
# brute-force version (distinct values of b * log(a)) isn't possible in the
# shell, as mpexpr doesn't do floats.  Luckily, it's fast enough.

for a in ${expr 2 100 seq} {
	for b in ${expr 2 100 seq} {
		echo ${expr $a $b '**'}
	}
} | sort | uniq | wc -l
