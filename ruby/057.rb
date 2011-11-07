#!/usr/bin/env ruby

# In the first one-thousand expansions of the continued fraction of sqrt(2),
# how many fractions contain a numerator with more digits than denominator?

# The approximate fraction for sqrt(2) is, famously, (P(n) + P(n-1))/P(n),
# where P(n) is the nth Pell number (A000129).  Brute forced it, but had to pop
# over to a language with easy access to infinite-precision integers.

# Pell numbers
p = Hash.new { |h,k| h[k] = 2 * h[k - 1] + h[k - 2] }
p[0] = 0
p[1] = 1

# Number of digits, in a way that tries to keep us from converting to floats.
# Apparently, you can't floor(Infinity).  Who could have guessed?
nd = Hash.new { |h,k|
	i, j = 0, k
	while j > 0
		j /= 10
		i += 1
	end

	h[k] = i
}

acc = 0
1.upto(1000) { |i|
	if(nd[p[i] + p[i - 1]] > nd[p[i]])
		acc += 1
	end
}
puts acc
