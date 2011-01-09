#! /usr/bin/env lua
-- What is the first term in the Fibonacci sequence to contain 1000 digits?

--- This algorithm is totally not doable in Lua.
-- This is the naive version, with the minor twist that we use Lua's coroutines
-- for the fibonacci number generation.  Unfortunately, Lua 5.1 doesn't do
-- bignums, so this is right out.
function totally_not_doable_in_lua()
	fibs = coroutine.create(function()
		local a, b, i = 1, 2, 1
		coroutine.yield(1, 1)
		while true do
			i = i + 1
			coroutine.yield(i, a)
			a, b = b, a + b
		end
	end)

	while true do
		_, n, f = coroutine.resume(fibs)
		s = string.format("%d", f)
		if string.len(s) == 1000 then
			print(n)
			break
		end
	end
end

-- Now this actually works.  It's a port of the Pez version of this problem.
phi = (math.sqrt(5) + 1) / 2
log10phi = math.log10(phi)
log10root5 = math.log10(5) * -0.5

function fib_digits(n)
	return (log10phi * n) + log10root5
end

function find_1k_digits()
	local i = 1
	while fib_digits(i) < 999 do
		i = i + 1
	end
	return i
end

print(find_1k_digits())
