#!/usr/bin/env ruby
# Given lines with a base/exponent pair on each line, determine which line
# number has the greatest numerical value.

# Uglier than the awk solution, but it was a little fun.

# 0.29s.  

NPROCS = (ENV['NPROCS'] || 6).to_i

require 'socket'

lines = File.readlines('data/099.txt').each_with_index.to_a

File.unlink '/tmp/euler099' rescue nil
s = UNIXServer.new('/tmp/euler099')

per_proc = lines.size / NPROCS
rem = lines.size % NPROCS

pids = []

NPROCS.times {
	tpl = lines[0, per_proc + rem]
	lines = lines[(per_proc + rem)..-1]
	pids << fork {
		ldone = 0
		max = tpl.inject([0, 0]) { |max,cur|
			b, p = cur[0].split(/,/, 2)
			v = p.to_f * Math.log(b.to_i)
			ldone += 1
			max[1] > v ? max : [cur[1] + 1, v]
		}
		c = UNIXSocket.new('/tmp/euler099')
		c.puts *max
		c.close
	}
	rem = 0
}

at_exit { pids.each { |p| Process.kill 9, p rescue nil }; s.close rescue nil }

last_n = []
NPROCS.times {
	conn = s.accept
	last_n << [conn.gets, conn.gets.to_f]
	conn.close rescue nil
}

puts last_n.max_by { |a| a[1] }[0]
