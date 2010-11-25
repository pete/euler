#! /usr/bin/env ruby

# If all the numbers from 1 to 1000 (one thousand) inclusive were written out
# in words, how many letters would be used?

# I totally intend to brute-force this one.

#class String; def length; self + ' '; end; end

def ones n
	return ''.length if n.zero?
	%w(one two three four five six seven eight nine)[n - 1].length
end

def tens n
	return ones(n) if n < 10
	case n
	when 10
		"ten".length
	when 11
		"eleven".length
	when 12
		"twelve".length
	when 13
		"thirteen".length
	when 15
		"fifteen".length
	when 18
		"eighteen".length
	when 14, 16, 17, 19
		ones(n % 10) + "teen".length
	else
		%w(twenty thirty forty fifty sixty seventy eighty ninety
		  )[(n / 10) - 2].length + ones(n % 10)
	end
end

def hundreds n
	h, t = n / 100, n % 100
	return tens(n) if h.zero?
	r = ones(h) + "hundred".length
	unless t.zero?
		r += "and".length + tens(t)
	end
	r
end

puts (1..999).inject(''.length) { |a,i| a + hundreds(i) } + "onethousand".length
