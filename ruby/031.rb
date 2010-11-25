#! /usr/bin/env ruby

# How many different ways can £2 be made using any number of coins?

# Two solutions in here, neither especially clean, but both were fun to write.

# The first Ruby version memoizes, and goes to lengths to avoid having to say
# the coin sizes more than once.  It manages to be fairly speedy, beating a few
# of the other solutions in this repo, including one of the Pez solutions.
# Most of the time spent, incidentally, is in these Hash/Array manipulations at
# the beginning.

$coins = coins = [200, 100, 50, 20, 10, 5, 2, 1]
$memo = Hash[*coins.zip(Array.new(coins.size){{}}).inject([], &:+)]
$next = Hash[*coins[0..-2].zip(coins[1..-1]).inject([], &:+)]

def p x, n
	return 0 unless x
	return $memo[x][n] if $memo[x][n]
	$memo[x][n] =
		if n < 0
			0
		elsif x == 1
			1
		else
			p($next[x], n) + p(x, n - x)
		end
end

t = Time.now.to_f
r = p(200, 200)
t = Time.now.to_f - t
printf "%d (%0.6f seconds)\n", r, t

# I thought it would be fun to do one like the Pez solution that generates the
# words.  This version generates the methods and memoizes, and is line-noisy in
# general.

module Kernel
	def p_memo(x, n, &b)
		((@memo ||= {})[x] ||= {})[n] ||= b[n]
	end

	def p1(x)
		1
	end

	m = :p1
	$coins[0..-2].reverse!.each { |c|
		newsym = :"p#{c}"
		oldsym = m
		define_method(newsym) { |n|
			p_memo(c, n) {
				if n < 0
					0
				else
					send(oldsym, n) + send(newsym, n - c)
				end
			}
		}
		m = newsym
	}
end

$memo = Hash[*coins.zip(Array.new(coins.size){{}}).inject([], &:+)]
t = Time.now.to_f
r = p200 200
t = Time.now.to_f - t
printf "%d (%0.6f seconds)\n", r, t
