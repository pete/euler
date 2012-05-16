# Find the pair of pentagonal numbers, P[j] and P[k], for which their sum and
# difference is pentagonal and D = |P[k]-P[j]| is minimised; what is the value
# of D?

# So, the idea here is to, for each pentagonal number P[n], check differences
# and sums of pentagonal numbers from P[n-1] to P[1], and see if we've got more
# pentagonal numbers.  It comes up with the correct answer, although the upper
# bound was chosen optimistically and I have not proven that it always minimizes
# D, but I suspect this to be the case, since the difference between P[k] and
# P[k-1] grows very quickly.

# 0.87s, 0.95s if the caching is removed from pentagon().  A bigger gain would
# be had by caching pentagon_inv(), but that's slightly more trouble than it's
# worth.

implement L044;

include "sys.m"; sys: Sys; print: import sys;
include "draw.m"; draw: Draw;
include "math.m"; math: Math; sqrt: import math;

pcache: array of int;
picache: array of int;

L044: module {
	init: fn(nil: ref Draw->Context, nil: list of string);
};

imax: con 26755; # pentagon_inv(2^30).  Larger sums won't fit.
cmax: con 37837; # pentagon_inv(2^31 - 1)

pentagon(n: int): int
{
	if(!pcache[n] || n > cmax)
		pcache[n] = (n * (3 * n - 1))/2;
	return pcache[n];
}

# Returns P^-1(x) for pentagonal x, returns the lower x otherwise.
pentagon_inv(x: int): int
{
	# According to Wikipedia:
	# (sqrt(24n+1)+1)/6
	return int ((sqrt(24.0 * real x + 1.0) + 1.0) / 6.0);
}

is_pentagonal(n: int): int
{
	return pentagon(pentagon_inv(n)) == n;
}

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;
	math = load Math Math->PATH;

	pcache = array[cmax] of { * => 0 };

	i, j, pi, pj, diff, sum: int;

	bf: for(i = 2; i < imax; i++) {
		pi = pentagon(i);
		for(j = i - 1; j > 0; j--) {
			pj = pentagon(j);
			diff = pi - pj;
			sum = pi + pj;
			if(is_pentagonal(diff) && is_pentagonal(sum))
				break bf;
		}
	}

	print("diff:%d sum:%d i:%d j:%d\n", diff, sum, i, j);
}
