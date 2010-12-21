#! /usr/bin/env lua
-- Find the largest prime factor of 600851475143.

function factor_out(n, f)
	while n % f == 0 do
		n = n / f
	end
	return n
end

function largest_factor(n)
	local f = 3

	n = factor_out(n, 2)
	if n == 1 then
		return n
	end

	f = 1
	while n ~= 1 do
		f = f + 2
		n = factor_out(n, f)
	end
	return f
end

print(largest_factor(600851475143))
