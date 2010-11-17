function ef(n)
	if n == 0 then
		return 2
	elseif n == 1 then
		return 8
	else
		return(4 * ef(n - 1) + ef(n - 2))
	end
end

function seftil(n)
	local sum = 0
	local cef = 0
	local c = 0
	while cef < n do
		sum = sum + cef
		cef = ef(c)
		c = c + 1
	end
	return sum
end

print(seftil(4000000))
