#! /usr/bin/awk -f

# How many different ways can £2 be made using any number of coins?

# 0.05s.  Pretty speedy for an interpreted language.

BEGIN {
	xs[200] = 100
	xs[100] = 50
	xs[50] = 20
	xs[20] = 10
	xs[10] = 5
	xs[5] = 2
	xs[2] = 1

	print p(200, 200)
}

function p(x, n) {
	if(x == 1) return 1
	if(n < 0) return 0
	return(p(xs[x], n) + p(x, n - x))
}
