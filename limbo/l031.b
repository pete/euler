# How many different ways can £2 be made using any number of coins?

# I did four solutions, to get a feel for Limbo and its speed characteristics.
# p() is a simple case statement with lots of redundancy (in C, I used the
# preprocessor for this, but as I understand it, Limbo has no preprocessor),
# p2() uses a list that it cdr's down, p3() is roughly equivalent but with array
# slicing, and p4() uses a (mostly empty) array as a lookup table.  They all
# take under 0.1 seconds on the only machine I have that'll run Inferno
# properly.  p() takes 0.04, p2() 0.06, p3() 0.08, and p4() 0.06, putting all of
# them roughly a notch below C, roughly on par with Pez/Lua/AWK, and a notch
# above Erlang.

implement L031;

include "sys.m";
sys: Sys;
include "draw.m";
next_x: array of int;

L031: module
{
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

# Out of the four solutions below, the case statement seems to be the speediest,
# by a hair.
p(x: int, n: int): int
{
	if(n < 0)
		return 0;
	
	case x {
		0 => return 0;
		1 => return 1;
		2 => return(p(1, n) + p(2, n - 2));
		5 => return(p(2, n) + p(5, n - 5));
		10 => return(p(5, n) + p(10, n - 10));
		20 => return(p(10, n) + p(20, n - 20));
		50 => return(p(20, n) + p(50, n - 50));
		100 => return(p(50, n) + p(100, n - 100));
		200 => return(p(100, n) + p(200, n - 200));
	}

	return 0;
}

# Takes slightly longer to run than p(200, 200), but is neater.
p2(x: list of int, n: int): int
{
	if(n < 0)
		return 0;

	if(hd x == 1)
		return 1;

	return(p2(tl x, n) + p2(x, n - hd x));
}

# This one is slightly slower than p2, probably as a result of all the
# slicing/copying.
p3(x: array of int, n: int): int
{
	if(n < 0)
		return 0;

	if(x[0] == 1)
		return 1;
	
	return(p3(x[1:], n) + p3(x, n - x[0]));
}

# This is roughly the same as p2, the list-based version.  hd/tl seem to have
# about the same overhead as a lookup (which makes sense), but take less space.
p4(x: int, n: int): int
{
	if(n < 0)
		return 0;
	
	if(x == 1)
		return 1;

	return(p4(next_x[x], n) + p4(x, n - x));
}

init(ctxt: ref Draw->Context, argv: list of string)
{

	sys = load Sys Sys->PATH;

	#sys->print("%d\n", p(200, 200));

	#sys->print("%d\n",
	#	p2(200 :: 100 :: 50 :: 20 :: 10 :: 5 :: 2 :: 1 :: nil, 200));

	#l := array[] of {200, 100, 50, 20, 10, 5, 2, 1}; 
	#sys->print("%d\n", p3(l, 200));

	next_x = array[201] of int;
	next_x[200] = 100;
	next_x[100] = 50;
	next_x[50] = 20;
	next_x[20] = 10;
	next_x[10] = 5;
	next_x[5] = 2;
	next_x[2] = 1;
	next_x[1] = 0;
	sys->print("%d\n", p4(200, 200));
}
