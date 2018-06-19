#!/usr/bin/env ruby
#
# What's the maximum digital sum for numbers a^b with a, b < 100?
#
# Using builtin bignums and brute-forcing a solution always feels cheap.  In
# this case, I thought I'd let it run while I thought about the solution a
# little harder, but it completed almost immediately.  The 5 was a guess,
# but you get the same results if you take it out; it just runs slower.
#
# 0.080s.

max = 0
cds = lambda { |x,y| t = 0; n = (x**y); while n > 0; t+=n%10; n/=10; end; t}
c = 0
99.step(10, -1) { |i|
	om = max
	99.step(10, -1) { |j|
		ds = cds[i,j]
		if ds >= max
			puts [i, j, ds].inspect
			max = ds
		end
	}
	if max == om
		c += 1
		break if c >= 5
	else
		c = 0
	end
}
puts max
