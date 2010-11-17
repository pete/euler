#! /usr/bin/env ruby

# Starting in the top left corner of a 2x2 grid, there are 6 routes (without
# backtracking) to the bottom right corner.
# How many routes are there through a 20x20 grid?

# I did this like a barbarian:  The trivial case for a 1x1 box is 2, it's 6 for
# a 2x2 box, 20 for a 3x3 box, and 70 for a 4x4 box.  Then I went to the Online
# Encyclopedia of Integer Sequences, and there was a formula that was easier to
# implement than counting to the 20th item on their list.

def fact n
	(1..n).inject(1, &:*)
end

def c2n_n n
	fact(2 * n) / (fact(n) ** 2)
end

n = (ARGV[0] || 20).to_i
puts c2n_n n
