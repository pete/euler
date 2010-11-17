#! /usr/bin/env ruby
# What is the 10,000th number in a list of integers from 1 to 100,000, sorted
# by radical?

# Runs in about 1.4 seconds.

require 'prime'

max = (ARGV[0] || 100_000).to_i
# 1 for the 0-indexing, and another because we skip the number 1:
sel = (ARGV[1] || 10_000).to_i - 2

$primes = Prime.take_while { |n| n < max }

# This one took about two minutes to run.  To put this in perspective, the bash
# version which mostly glues together the factor and sed commands takes seven
# minutes on my machine.  Yes, that's pretty slow.
def naive_rad(n)
	$primes.select { |p| (n%p).zero? }.inject(&:*)
end

# This was what I had planned to do had the other one taken an unreasonable
# amount of time.  It only takes about 1.4 seconds.
$rad = {1=>1}
$primes.each { |p| $rad[p] = p }
def rad(n, ps = $primes.dup)
	return $rad[n] if $rad[n]
	sn = n
	ps.shift until((n%ps[0]).zero?)
	f = ps.shift
	n /= f while((n%f).zero?)
	$rad[sn] = f * rad(n, ps)
end

puts((2..max).to_a.map! { |n| [rad(n), n] }.sort![sel][1])
