# Find the first arrangement of discs such that there is a 50% chance of taking
# two blue disks, and there are more than 1e12 discs total.

# Solved in terms of the number of blues (quadratic equation), and ran a few,
# checked OEIS, found http://oeis.org/A011900 , and the answer is there.  (The
# other pair, the total number of chips, is http://oeis.org/A046090 .)  But if I
# just pull a number from there, then I don't have a program to check in.  The
# equation for generating numbers in the series is right there, though,
# so...easy.  Kind of disappointing when a search engine has the answer, but
# there are always more problems.
implement L100;

include "sys.m"; sys: Sys; stderr: ref sys->FD;
include "bufio.m"; bufio: Bufio; Iobuf: import bufio;
include "string.m"; str: String;
include "draw.m";
include "math.m"; math: Math;

L100: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

# Blue:total approaches 1/sqrt(2).  1e12/sqrt(2) is about this:
min: con big 707106781186;

f(t: int): big
{
	if(t == 0)
		return big 1;

	if(t == 1)
		return big 3;

	return((big 6 * f(t - 1)) - f(t - 2) - big 2);
}

init(ctxt: ref Draw->Context, argv: list of string)
{
	sys = load Sys Sys->PATH;
	bufio = load Bufio Bufio->PATH;

	i := 1;
	r := big 0;

	while(r < min) {
		i++;
		r = f(i);
		# And this line prints out a table.
		#sys->print("f(%d) = %bd\n", i, r);
	}

	sys->print("f(%d) = %bd\n", i, r);
}
