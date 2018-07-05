#!/usr/bin/awk -f

# If d[n] represents the nth digit of the fractional part of the Champernowne
# constant, find the value of the following expression.
# 	d[1] · d1[0] · d[100] · d[1000] · d[10000] · d[100000] · d[1000000]

BEGIN {
	#dumb_version()
	only_slightly_less_dumb_version()
}

# The dumb version looks uninteresting.
# In fact, as an algorithm on its own, it is.
# But it's interesting to run it under different awks, because they show wildly
# different performance when allocating a 1,000,005-character string piece by
# piece.
# On the same machine:
# 	mawk:        00:12.6 (4.4 user, 8.1 sys)
# 	gawk:        01:39.7 (1:39.4 user, 0.2 sys)
# 	Busybox awk: 02:20.7 (1:26.6 user, 53.8 sys)
# 	P9P awk:     24:27.4 (24:11.5 user, 13.3 sys)
function dumb_version(	i,s,r) {
	for(i = 1; length(s) < 1000000; i++)
		s = s i
	r = 1
	for(i = 10; i < 1000001; i *= 10)
		r *= substr(s, i, 1)
	print r, length(s)
}

# *Still* not an interesting algorithm.  But since we're not making an unholy
# string, it's much faster, and none of the awks involved run an order of
# magnitude slower than the others.
# 	mawk:        0.055s
# 	gawk:        0.067s
# 	Busybox awk: 0.119s
# 	P9P awk:     0.152s
function only_slightly_less_dumb_version() {
	c = 10
	a = 9
	i = 10
	r = 1
	while(c < 1000001) {
		a += length(i)
		if(a >= c) {
			r *= substr(i, length(i) + c - a, 1)
			c *= 10
		}
		i++
	}
	print r
}
