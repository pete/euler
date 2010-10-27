#!/usr/bin/env ruby
# Find the first Fibonacci number 
c, p = 1, 1
i = 2
loop {
	break if c.to_s.length >= 1000
	c, p = c+p, c
	i += 1
}

puts i,
	"And, just for the sake of pedantry, I want to point out that it is a ",
	"little sad that log10(c) comes out to '#{Math.log10(c)}'.  I didn't ",
	"wanna use strings here."

# The above runs in under half a second on my machine (Ruby 1.9), so the
# following is relatively superfluous, but I did want to do a port of the Pez
# version:

Phi = (Math.sqrt(5.0) + 1.0) / 2.0
Log10Phi = Math.log10 Phi
Log10Root5 = Math.log10(5.0) * -0.5

def fdigits n
	(Log10Phi * n) + Log10Root5
end

def find_1k_digits
	i = 1
	while fdigits(i) < 999
		i += 1
	end
	return i
end

puts find_1k_digits
