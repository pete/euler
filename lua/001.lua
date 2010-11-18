-- Find the sum of all the multiples of 3 or 5 below 1000.

-- You can do this by hand fairly easily.  I am new to Lua, though, and it was
-- bugging me that I had not checked in a solution to the first problem.

function triangle(n)
	return((n * (n + 1)) / 2)
end

function sum_multiples(n, limit)
	return(n * triangle(math.floor((limit - 1) / n)))
end

print(sum_multiples(3, 1000) + sum_multiples(5, 1000) - sum_multiples(15, 1000))
