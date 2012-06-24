#!/dis/sh
# I had no code for this one.  I suspect I just did it in a REPL somewhere.
# Anyway, I solved it before I knew anything about Inferno, so I can't have done
# it in the Inferno shell.  Here's a solution, not a great one, 1.04s.

load mpexpr std echo

for a in ${expr 2 100 seq} {
	for b in ${expr 2 100 seq} {
		echo ${expr $a $b '**'}
	}
} | sort | uniq | wc -l
