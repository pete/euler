# For which value of p  1000, is the number of solutions maximised?

# 0.16s

implement L039;

include "sys.m"; sys: Sys; stderr: ref sys->FD;
include "math.m"; math: Math; sqrt: import math;
include "draw.m";

L039: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;
	math = load Math Math->PATH;

	ps := array[1001] of { * => 0 };
	(n, max) := (0, 0);
	a, b, c, as, bs, cs, p: int;

	for(a = 1; a <= 998; a++) {
		as = a * a;
		for(b = 1; b <= a; b++) {
			bs = b * b;
			cs = as + bs;
			c = int sqrt(real cs);
			if(c * c == cs) {
				p = a + b + c;
				if(p <= 1000)
					ps[p]++;
			}
		}
	}

	n = max = 0;
	for(p = 1; p <= 1000; p++) {
		if(ps[p] > max) {
			n = p;
			max = ps[p];
		}
	}

	sys->print("%d (%d solutions)\n", n, max);
}
