#!/usr/bin/env ruby
# What is the sum of the digits of the number 2^1000?

# I did this one in IRB and forgot to put a solution in here.  It's trivial
# anyway.

puts((2 ** 1000).to_s.split(//).map(&:to_i).inject(&:+))

# If you read that and thought, "Pete doesn't know how to do modular
# exponentiation!", then you were correct.  I'll probably have to learn for
# some of the later problems, but this was fast enough in the mean time.
