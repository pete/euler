#!/usr/bin/env ruby

# Find the sum of the digits in the number 100!

# See the comments for the Ruby solution to #16.

def fact n
	return 1 if n < 2
	n * fact(n - 1)
end

puts fact(100).to_s.split(//).map(&:to_i).inject(&:+)
