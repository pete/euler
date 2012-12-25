# Find the sum of the only ordered set of six cyclic 4-digit numbers for which
# each polygonal type: triangle, square, pentagonal, hexagonal, heptagonal,
# and octagonal, is represented by a different number in the set.

# 0.004s.  Basically, the idea is to build up an array of bitmasks representing
# if a number is triangular, hexagonal, etc., and then, starting at the first
# plausible 4-digit octagonal number, loop over all the octagonal numbers, and
# check for a cycle.  The check starts with a mask representing all the sets,
# and knocks one bit out at a time to keep track of where it started.  If it
# runs out of bits (i.e., it has found one number from each set) and it is back
# where it started (i.e., this is a cycle rather than a chain), then we're done.

implement L061;

include "sys.m"; sys: Sys;
include "draw.m";

L061: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

ns := array[10000] of { * => 0 };
sq, tr, pt, hx, hp, oc: con 1<<iota;
all: con sq|tr|pt|hx|hp|oc;

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;
	bfs := array[] of {
		(sq, sqf),
		(tr, trf),
		(pt, ptf),
		(hx, hxf),
		(hp, hpf),
		(oc, ocf),
	};

	for(i := 0; i < len bfs; i++) {
		(n, f) := bfs[i];
		fill(n, f);
	}

	# Starting point is from the positive root of ocf(n) where the first
	# number that could produce a 4-digit number is 1010, solution is a little
	# over 18, so we check starting at 19.  Unfortunately, the solution starts
	# with ocf(21), so we don't iterate too far.
	l := ocf(19);
	i = 19;
	while(l < len ns) {
		r := check(l, all, l);
		if(r > 0) {
			sys->print("%d (%d = ocf(%d))\n", r, l, i);
			break;
		}
		i++;
		l = ocf(i);
	}
}

check(n: int, mask: int, start: int): int
{
	if(!mask && n == start)
		return 0;

	l2 := 100 * (n % 100);
	if(l2 < 10)
		return -1;

	bits := mask & ns[n];
	# For each bit set to 1 in mask&bfs[n],
	while(bits) {
		b := bits & ~(bits - 1);
		nmask := mask & ~b;
		bits &= bits - 1;

		# For each number in (100*(n%100)+10,100*(n%100)+99),
		for(c := l2 + 10; c < l2 + 100; c++) {
			r := check(c, nmask, start);
			if(r >= 0) {
				#sys->print("%d\n", n); # You can uncomment to see the cycle.
				return n + r;
			}
		}
	}

	return -1;
}

fill(n: int, f: ref fn(i: int): int)
{
	l := f(0);
	for(i := 1; l < 10000; i++) {
		ns[l] = ns[l] | n;
		l = f(i);
	}
}

sqf(n: int): int
{
	return n * n;
}

trf(n: int): int
{
	return (n * (n + 1))/2;
}

ptf(n: int): int
{
	return (n * (3 * n - 1)) / 2;
}

hxf(n: int): int
{
	return n * (2 * n - 1);
}

hpf(n: int): int
{
	return (n * (5 * n - 3)) / 2;
}

ocf(n: int): int
{
	return n * (3 * n - 2);
}
