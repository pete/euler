#!/bin/bash
# How many Sundays fell on the first of the month during the twentieth century
# (1 Jan 1901 to 31 Dec 2000)?

# This is trivial to do with math, making math an extremely unattractive
# prospect in this case.  Like the solution for #187, the bottleneck is the
# grep.  Unlike that one, though, this solution finishes in under two seconds.
# (Although that depends on the number of logical CPUs in your machine, since
# it forks 2400 processes.)

for month in $(seq 1 12); do
	for year in $(seq 1901 2000); do
		cal $month $year | grep '^ 1 ' &
	done
done | wc -l
