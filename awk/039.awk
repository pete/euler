#!/usr/bin/awk -f
# For which value of p  1000, is the number of solutions maximised?
# 0.68s gawk, 0.57s mawk, 1.01s busybox awk

BEGIN {
	for(i = 1; i <= 998; i++)
		sq[i * i] = i

	for(i in sq) {
		a = sq[i]
		for(j in sq) {
			b = sq[j]
			if(i + j in sq && b <= a) {
				c = sq[i + j]
				p = a + b + c
				if(p < 1000)
					ps[p]++
			}
		}
	}

	max = 0
	s = 0
	for(i in ps) {
		if(ps[i] > max) {
			max = ps[i]
			s = i
		}
	}

	printf("%d (%d)\n", s, max)
}
