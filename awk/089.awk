#! /usr/bin/awk -f

# Minify Roman numerals and report how many characters were saved.
# 
# It was not an interesting problem, but there is a special trophy for solving
# problems whose numbers appear in the Fibonacci sequence.  awk has some
# restrictions on what sort of things you can put into an array and has, of
# course, no array literals, so I just scattered copypasta around the place to
# get an answer as quickly as possible.
# 
# I went through the entire forum, and *nobody* did a solution that used yacc.
# [SAD FACE EMOTICON]
# 
# 0.02s.

{t += length($0) - length(repr(parse($0)))}
END { print t }

# This function is not winning any awards for terseness.
# It probably could have been done as a loop.
function repr(i,   s,x,r) {
	s = ""
	x = i % 10
	i -= x
	i /= 10
	if(x == 9) {
		s = "IX"
		x = 0
	} else if(x == 4) {
		s = "IV"
		x = 0
	} else if(x >= 5) {
		s = "V"
		x -= 5
	}
	while(x > 0) {
		s = s "I"
		x--
	}
	r = s
	s = ""
	
	x = i % 10
	i -= x
	i /= 10
	if(x == 9) {
		s = "XC"
		x = 0
	} else if(x == 4) {
		s = "XL"
		x = 0
	} else if(x >= 5) {
		s = "L"
		x -= 5
	}
	while(x > 0) {
		s = s "X"
		x--
	}
	r = s r
	s = ""

	x = i % 10
	i -= x
	i /= 10
	if(x == 9) {
		s = "CM"
		x = 0
	} else if(x == 4) {
		s = "CD"
		x = 0
	} else if(x >= 5) {
		s = "D"
		x -= 5
	}
	while(x > 0) {
		s = s "C"
		x--
	}
	r = s r
	s = ""

	while(i > 0) {
		r = "M" r
		i--
	}

	return r
}

function parse(n,   t) {
	t = 0
	while(n != "") {
		if(sub(/^CM/, "", n))
			t += 900
		else if(sub(/^CD/, "", n))
			t += 400
		else if(sub(/^XL/, "", n))
			t += 40
		else if(sub(/^XC/, "", n))
			t += 90
		else if(sub(/^XL/, "", n))
			t += 40
		else if(sub(/^IX/, "", n))
			t += 9
		else if(sub(/^IV/, "", n))
			t += 4
		else if(sub(/^M/, "", n))
			t += 1000
		else if(sub(/^D/, "", n))
			t += 500
		else if(sub(/^C/, "", n))
			t += 100
		else if(sub(/^L/, "", n))
			t += 50
		else if(sub(/^X/, "", n))
			t += 10
		else if(sub(/^V/, "", n))
			t += 5
		else if(sub(/^I/, "", n))
			t++
	}
	return t
}
