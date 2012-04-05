# Find the sum of all the positive integers which cannot be written as the sum
# of two abundant numbers.

# So, first we build a list of abundant numbers.  Then, going from 1 to 20161
# inclusive ( http://en.wikipedia.org/wiki/Abundant_number ), we add to the sum
# each one that can't be shown to be a sum of abundant numbers.  Very
# brute-force.

# 0.23s

# A bonus awk solution:
# curl -s http://oeis.org/A048242/b048242.txt | time awk '{t += $2}END{print t}'
# But that is cheating.
implement L023;

include "sys.m"; sys: Sys;
include "math.m"; math: Math;
include "draw.m";

abundants: list of int;
sum_of_abundants: array of int;

L023: module {
	init:	fn(ctxt: ref Draw->Context, argv: list of string);
};

# Returns the sum of the proper divisors of n.
sigma1(n: int): int
{
	i: int;
	sum := 1;
	sqrtn := int math->sqrt(real n);

	for(i = 2; i <= sqrtn; i++) {
		if((n % i) == 0)
			sum += (n / i) + i;
	}

	# Special-cased; if n is a perfect square, we want to count that divisor
	# only once.
	if(sqrtn * sqrtn == n)
		sum -= sqrtn;

	return sum;
}

is_abundant(n: int): int
{
	return(sigma1(n) > n);
}

# Builds a list of abundant numbers.  Since the highest integer that is not the
# sum of two abundants is 20161, we need the abundants up to 20161-12=20149.
build_abundants()
{
	i: int;

	abundants = nil;

	for(i = 12; i < 20150; i++) {
		if(is_abundant(i))
			abundants = i :: abundants;
	}
}

build_abundant_sums()
{
	a := abundants;
	b: list of int;
	n: int;

	sum_of_abundants = array[20162] of { * => 0 };
	
	while(a != nil) {
		n = hd a;
		a = tl a;
		b = abundants;

		while(b != nil && (hd b > n || hd b + n > 20161))
			b = tl b;

		while(b != nil) {
			sum_of_abundants[n + hd b] = 1;
			b = tl b;
		}
	}
}

init(ctxt: ref Draw->Context, argv: list of string)
{
	sys = load Sys Sys->PATH;
	math = load Math Math->PATH;

	i: int;
	sum := 0;

	build_abundants();
	build_abundant_sums();

	for(i = 0; i < 20162; i++) {
		if(!sum_of_abundants[i])
			sum += i;
	}

	sys->print("%d\n", sum);
}
