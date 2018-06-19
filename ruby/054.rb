#!/usr/bin/env ruby
#
# Here's a tiny data file, how many poker hands does player 1 win?
#
# This one's not interesting, just tedious.  0.084s.

TCard = Hash.new { |h,k|
	h[k] = k.to_i(10) 
}.merge!('T' => 10, 'J' => 11, 'Q' => 12, 'K' => 13, 'A' => 14)

# The definition of "correct" here is "as specified by the problem" rather than
# "as specified by the rules of poker".  The problem doesn't rank suits.
TSuit = Hash.new { |h,k| h[k] = (h.values.max || 0) + 1 }

def pc c
	[TCard[c[0]], TSuit[c[1]]]
end

def rh h
	ic = h.last.first

	straightp = h.each_with_index.all? { |c, i|
		i == 0 || c[0] == h[i-1][0] + 1
	}

	flushp = h[1..-1].all? { |c| c[1] == h[0][1] }

	count = Hash.new { |h,k| h[k] = 0 }
	h.each { |c| count[c[0]] += 1 }
	pairp = count.values.include?(2)
	threep = count.values.include?(3)
	fourp = count.values.sort == [1, 4]
	fullp = count.values.sort == [2, 3]
	tpp = count.values.sort == [1, 2, 2]
	if [pairp, threep, fourp].any?
		ic = count.to_a.map(&:reverse).sort.last.last
	end

	hv = if straightp && flushp
			9
		elsif fourp
			8
		elsif fullp
			7
		elsif flushp
			6
		elsif straightp
			5
		elsif threep
			4
		elsif tpp
			3
		elsif pairp
			2
		else
			1
		end

	[hv, ic, *h.map(&:first).reverse]
end

puts File.read("#{__dir__}/../data/054.txt").split(/\n/).inject(0) { |a,l|
	cs = l.split(/\s/).map { |c| pc(c) }
	p1, p2 = cs.each_slice(5).to_a.map(&:sort)
	r1, r2 = rh(p1), rh(p2)
	a + (((r1 <=> r2) + 1) / 2)
}
