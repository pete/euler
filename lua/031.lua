#! /usr/bin/env lua
-- How many different ways can £2 be made using any number of coins?

xs = {
	[200] = 100,
	[100] = 50,
	[50] = 20,
	[20] = 10,
	[10] = 5,
	[5] = 2,
	[2] = 1
}

function p(x, n)
	if x == nil then
		return 0
	end

	if x == 1 then
		return 1
	end

	if n < 0 then
		return 0
	end

	return(p(xs[x], n) + p(x, n - x))
end

print(p(200, 200))
