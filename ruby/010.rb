#!/usr/bin/env ruby

# Find the sum of all primes under 2,000,000.

# This solution feels like cheating!

require 'prime'
puts Prime.take_while { |i| i < 2_000_000 }.inject(&:+)
