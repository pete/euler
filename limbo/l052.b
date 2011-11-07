# Find the smallest positive integer, x, such that 2x, 3x, 4x, 5x, and 6x,
# contain the same digits.

implement L052;

include "sys.m"; sys: Sys; stderr: ref sys->FD;
include "math.m"; math: Math;
include "draw.m";

L052: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

fill_digits(n: int): array of int
{
	digits := array[10] of { * => 0 };

	while(n > 0) {
		last := n % 10;
		n /= 10;
		digits[last]++;
	}

	return digits;
}

same_digits(a: array of int, b: array of int): int
{
	for(i := 0; i < 10; i++)
		if(a[i] != b[i])
			return 0;

	return 1;
}

check_n(n: int): int
{
	digits: array of int;
	c: array of int;

	# First, since to contain the same digits a number has to at least have
	# the same number of digits, we do a quick sanity check:
	if(math->floor(math->log10(real n)) !=
	   math->floor(math->log10(real (n * 6))))
		return 0;

	digits = fill_digits(n);
	for(i := 2; i <= 6; i++) {
		c = fill_digits(n * i);
		if(!same_digits(digits, c)) {
			return 0;
		}
	}
	return 1;
}

init(ctxt: ref Draw->Context, argv: list of string)
{
	sys = load Sys Sys->PATH;
	math = load Math Math->PATH;

	for(i := 1; i < 16r7fffffff; i++) {
		if(check_n(i)) {
			sys->print("%d\n", i);
			#exit;
		}
	}
}
