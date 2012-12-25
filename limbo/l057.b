# In the first one-thousand expansions of √2, how many fractions contain a
# numerator with more digits than denominator?

# √2 = 1 + 1/(2 + 1/(2 + 1/(2 + ⋯ ))) = 1.414213⋯
# 1 + 1/2 = 3/2 = 1.5
# 1 + 1/(2 + 1/2) = 7/5 = 1.4
# 1 + 1/(2 + 1/(2 + 1/2)) = 17/12 = 1.41666⋯
# ⋯

# 0.014s.  A fairly straightforward transliteration of the Ruby version, but
# without the caching for the digits, and with a slightly faster way of
# calculating the number of digits.

implement L057;

include "sys.m"; sys: Sys;
include "keyring.m"; keyring: Keyring;
	IPint: import keyring;
include "draw.m";

L057: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

zero, one, two: ref IPint;
pell := array[1001] of ref IPint;
log10_2: con 0.3010299956639812;

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;
	keyring = load Keyring Keyring->PATH;

	r := 0;
	pell[0] = zero = IPint.inttoip(0);
	pell[1] = one = IPint.inttoip(1);
	pell[2] = two = IPint.inttoip(2);

	for(i := 3; i < 1001; i++) {
		pell[i] = two.mul(pell[i - 1]).add(pell[i - 2]);
		if(digits(pell[i].add(pell[i-1])) > digits(pell[i]))
			r++;
	}

	sys->print("%d\n", r);
}

digits(n: ref IPint): int
{
	return int (real n.bits() * log10_2);
	return len n.iptostr(10);
}
