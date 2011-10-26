#!/usr/bin/awk -f

# f(n | n is even) = n/2
# f(n | n is odd)  = 3n + 1
# Which integer under 1,000,000 requires the largest number of applications of
# f(n) to reach 1?

# This is basically a transliteration of the Pez version of this program.  It
# runs in 5.6s under gawk.  It segfaults mawk on my machine. :/

BEGIN {
	cmap[1] = 1
	rmap[1] = 1

	final = max_steps(1000000)
	print(final " (" cmap[final] " steps.)")
}

function collatz(n) {
	if(n % 2) return n * 3 + 1
	return n / 2
}

function csteps(n, steps) {
	if(n in cmap) return cmap[n]
	steps = csteps(collatz(n)) + 1
	cmap[n] = steps
	rmap[steps] = n
	return steps
}

function find_max(lim, max, c) {
	max = 0
	for(i = 1; i < lim; i++) {
		c = csteps(i)
		if(c > max) max = c
	}
	return max
}

function max_steps(lim) {
	return rmap[find_max(lim)]
}
