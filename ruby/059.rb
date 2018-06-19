#!/usr/bin/env ruby
#
# Brute-force a three-character key.
#
# So, my reasoning was that since it's supposed to decrypt to English text, it
# should be ridiculously simple by just finding which character decrypts the
# largest number of spaces.  That actually gave the password 'god', (See the
# movie "Hackers".) but the form didn't like that!  So I decided to try 'e'.  To
# make a long story short, I misread the problem:  you're not supposed to enter
# the key, but the sum of the ASCII values of the decrypted text.
# 
# 0.035s

data = File.read("#{__dir__}/../data/059.txt").split(/,/).map { |c| c.to_i }

k = ''

trips = data.each_slice(3).to_a

likely = (0x20..0x7e).to_a.concat([9, 0xa, 0xd])

tc = ' '.codepoints.first

puts tc.inspect

3.times {
	ft = Hash.new { |h,k| h[k] = 0 }
	trips.each { |t| x = t.shift; ft[x] += 1 if x }
	h = ft.to_a.sort_by { |c,f| -f }
	while h.size > 0
		c, * = h.shift
		pc = c ^ tc
		if((0x61..0x7a).include?(pc) &&
		   ft.keys.all? { |x| likely.include?(x ^ pc) })
			k << pc.chr
			break
		end
	end
}
puts k.inspect,
	data.each_with_index.map { |d,i| d ^ k.codepoints[i % k.length] }.inject(&:+)

# This brute-force approach appeared to successfully decrypt the text, and
# gave the key 'god' again, so I re-read carefully and noticed my mistake.
# This version is slow as hell by comparison.

('aaa'..'zzz').each { |k|
	kc = k.codepoints.cycle; kc.next; kc.next

	next unless dec.all? &likely.method(:include?)
	s = dec.pack('C*')
	puts k, s if s.include?(' the ')
} if false
