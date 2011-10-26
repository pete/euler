#!/usr/bin/awk -f

# Given lines with a base/exponent pair on each line, determine which line
# number has the greatest numerical value.

# Basic property of logarithms, courtesy of Wikipedia:
# 	a^b = e^(b * log(a))
# So, b * log(a) can be used to compare, and is quick and easy besides.

# If you guessed that I am, at this point, just going through the problems that
# have CSV files and using awk to process them, then you have guessed correctly
# because that is how I decided to do this one.  After checking the forum page
# for this, though, I found that I'm not the only one to have done an awk
# solution, and saw this clever one-liner by a guy called 'mpersano':
# 	t = log($1)*$2 > m { m = log($1)*$2; l = NR } END { print l }
# Sure beats mine.

# 0m0.004s

BEGIN {
	lmax = 0
	max = 0
}

{
	r = $2 * log($1)
	if(r > max) {
		lmax = NR
		max = r
	}
}

END {
	print lmax, max
}

