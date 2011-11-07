# Find the sum of all the numbers that can be written as the sum of fifth powers
# of their digits.

# 0.24s.  It's always disappointing when the naive solution runs in under a
# second.

implement L030;

include "sys.m"; sys: Sys; stderr: ref sys->FD;
include "draw.m";

L030: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

sum5ths(x: int): int
{
	sum := 0;
	i: int;

	while(x > 0) {
		i = x % 10;
		x = x / 10;
		sum += i * i * i * i * i;
	}

	return sum;
}

init(ctxt: ref Draw->Context, argv: list of string)
{
	sys = load Sys Sys->PATH;
	stderr = sys->fildes(2);

	total := 0;
	# 9^5 * 6.  9^5 * 7 has only six digits, so the cut-off is 9^5 * 6.
	for(i := 10; i < 354294; i++) {
		if(i == sum5ths(i)) {
			total += i;
		}
	}
	
	sys->print("%d\n", total);
}
