# Find the last 10 digits of 28433 * 2^7830457 + 1

# 0.01s.  Semi-cheating:  IPint has a modular exponentiation function.

implement L097;

include "sys.m"; sys: Sys;
include "draw.m";
include "keyring.m";
	keyring: Keyring;
	IPint: import keyring;

L097: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;
	keyring = load Keyring Keyring->PATH;

	d10 := IPint.strtoip("10000000000", 10);
	n := IPint.inttoip(2).
		expmod(IPint.inttoip(7830457), d10).
		mul(IPint.inttoip(28433)).
		add(IPint.inttoip(1));
	n = n.mod(d10);
	sys->print("%s\n", n.iptostr(10));
}
