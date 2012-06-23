#!/dis/sh

# How many Sundays fell on the first of the month during the twentieth century
# (1 Jan 1901 to 31 Dec 2000)?

# A direct port of my bash solution for the same problem.  It takes about as
# long to run without JIT, faster by about 15% with JIT enabled.

load std expr

for month in ${expr 1 12 seq} {
	for year in ${expr 1901 2000 seq} {
		cal $month $year | grep '^ 1 ' &
	}
} | wc -l
