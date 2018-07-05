#!/usr/bin/env ruby
# Find ∑ S for every pair of consecutive primes with 5 ≤ p1 ≤ 1000000,
# S being the smallest multiple of the next prime after p1 that ends with p1.
# 
# 12 minutes(!).  Look at the Racket version.

require 'prime'

# This solution took 22 *minutes*.  It ran longer than it took to port to
# Racket.  The Racket version, a direct translation, I killed when it hit
# the 45-minute mark.  It turns out that if you know what a Chinese remainder
# is, these are trivial to calculate.
def find_s a, b
	m = 10 ** Math.log10(a).ceil
	n = b
	b *= 2
	loop {
		n += b
		return n if n % m == a
	}
end

# The Chinese remainder is basically Euler's calculation for GCD but done
# in reverse.  Instead of that, because I wrote a better solution in Racket,
# please enjoy this alternative dopey solution, which is a minor optimization
# of the above.
def find_s a, b
	m = 10 ** Math.log10(a).ceil
	c = m + a
	while c % b != 0
		c += m
	end
	c
end

i = 0
primes = Prime.take_while { |n| (i < 1_000_000).tap { i = n } }[2..-1]
puts primes[0..-2].zip(primes[1..-1]).inject(0) { |t,(a,b)|
	t + find_s(a,b)
}
