# Find the sum of all multiples of 3 or 5 below 1000.
implement L001;

include "sys.m";
sys: Sys;
include "draw.m";

L001: module
{
	init:	fn(ctxt: ref Draw->Context, argv: list of string);
};

triangle(n : int) : int
{
	return((n * (n + 1)) / 2);
}

sum_multiples(n : int, limit : int) : int
{
	return(n * triangle((limit - 1) / n));
}

init(ctxt: ref Draw->Context, argv: list of string)
{
	sys = load Sys Sys->PATH;
	sys->print("%d\n", sum_multiples(3, 1000) + sum_multiples(5, 1000) -
			sum_multiples(15, 1000));
	# PITA:  Even if you use the 'exit' statement, Limbo apparently "exits
	# with signal 9".  Is it kill -9'ing itself?  Does the emulator just run
	# off the bottom of the program if it is out of code to run?
	exit;
}
