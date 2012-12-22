# How many Lychrel numbers are there below ten thousand?

# Given by the problem, anything requiring more than 50 iterations is a
# Lychrel number.

# 2.617s. Spawns one process per candidate, and then waits to collect all of
# the candidates.  The check is roughly equivalent to what it seems everyone
# else did from a glance through the forum.  (Some people noted that 25 as an
# upper limit works fine as well; using 25 rather than 50 as given in the
# problem drops the runtime to 1.705s.)

# A version using 64-bit ints instead of IPints gave the correct answer, but
# several of the numbers overflowed, so that was awful, so I ported it to IPint.
# That version took just a hair over 2s, so not much time was lost except that
# IPints' notation is somewhat less convenient.

implement L055;

include "sys.m"; sys: Sys;
include "draw.m";
include "keyring.m";
	keyring: Keyring;
	IPint: import keyring;

L055: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

start: con 196;  # First Lychrel number
stop: con 10000;
cs := array[11] of ref IPint;

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;
	keyring = load Keyring Keyring->PATH;

	n := 0;
	w := 0;
	c := chan of int;

	fillconsts();
	for(w = start; w < stop; w++) {
		spawn checklychrel(c, w);
	}

	w -= start;
	while(w--)
		n += <-c;
	sys->print("%d\n", n);
}

checklychrel(c: chan of int, n: int)
{
	r := islychrel(IPint.inttoip(n));
	c <-= r;
}

islychrel(n: ref IPint): int
{
	for(i := 0; i < 50; i++) {
		n = n.add(rev(n));
		if(n.eq(rev(n)))
			return 0;
	}
	return 1;
}

rev(n: ref IPint): ref IPint
{
	s := cs[0];
	for(i := 0; n.cmp(cs[0]) > 0; i++) {
		(div, mod) := n.div(cs[10]);
		s = s.mul(cs[10]).add(mod);
		n = div;
	}
	return s;
}

fillconsts()
{
	for(i := 0; i < len cs; i++)
		cs[i] = IPint.inttoip(i);
}
