#!/usr/bin/env ruby
# f(n | n is even) = n/2
# f(n | n is odd)  = 3n + 1
# Which integer under 1,000,000 requires the largest number of applications of
# f(n) to reach 1?

$map = { 1 => 1 }
$reverse = {}

def collatz n
	v = $map[n] ||= 1 + (n % 2 == 0 ? collatz(n / 2) : collatz(3 * n + 1))
	$reverse[v] = n
	v
end

limit = 1_000_000
1.step(limit) { |n| collatz n }
puts "%d (%d steps.)" % $reverse.max.reverse

