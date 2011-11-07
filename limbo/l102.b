# Find the number of triangles for which the interior contains the origin.

# This is intentionally split up too much.  It's based on my Erlang solution,
# and I've ported it to Limbo to teach myself some scanf, concurrency, and I/O.

# Runs on a Thinkpad T60 (32-bit, dual 1.83GHz) in 0.06s.  By way of comparison,
# on the same machine, the Erlang version (of which this program is a rough
# transliteration) runs in 0.24s, and the awk solution runs in 0.02s.

# I should note here that, had I screwed my head on straight when writing this,
# I would have used ADTs (Limbo's "structs" that more resemble objects) or at
# least tuples instead of passing everything as a ball of ints.

implement L102;

include "sys.m"; sys: Sys; stderr: ref sys->FD;
include "bufio.m"; bufio: Bufio; Iobuf: import bufio;
include "string.m"; str: String;
include "draw.m";

tfile: con "/usr/pete/102.txt";

L102: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

collector(in: chan of int, out: chan of int)
{
	acc := 0;
	c := 1;
	while(c = <-in)
		acc++;
	
	out <- = acc;
}

vector_sub(x1: int, y1: int, x2: int, y2: int): (int, int)
{
	return (x1 - x2, y1 - y2);
}

dot_prod(x1: int, y1: int, x2: int, y2: int): real
{
	return real(x1 * x2 + y1 * y2);
}

contains_origin(x1: int, y1: int, x2: int, y2: int, x3: int, y3: int): int
{
	(v0x, v0y) := vector_sub(x3, y3, x1, y1);
	(v1x, v1y) := vector_sub(x2, y2, x1, y1);
	(v2x, v2y) := vector_sub(0, 0, x1, y1);

	d00 := dot_prod(v0x, v0y, v0x, v0y);
	d01 := dot_prod(v0x, v0y, v1x, v1y);
	d02 := dot_prod(v0x, v0y, v2x, v2y);
	d11 := dot_prod(v1x, v1y, v1x, v1y);
	d12 := dot_prod(v1x, v1y, v2x, v2y);

	inv := 1.0 / (d00 * d11 - d01 * d01);
	u := inv * (d11 * d02 - d01 * d12);
	v := inv * (d00 * d12 - d01 * d02);

	return((u > 0.0) && (v > 0.0) && ((u + v) < 1.0));
}

checker(in: chan of (int, int, int, int, int, int, int),
        out: chan of int)
{
	contp, x1, y1, x2, y2, x3, y3 : int;

	(contp, x1, y1, x2, y2, x3, y3) = <-in;
	while(contp) {
		if(contains_origin(x1, y1, x2, y2, x3, y3))
			out <-= 1;
		(contp, x1, y1, x2, y2, x3, y3) = <-in;
	}
	
	out <-= 0;
}

parser(in: chan of (int, string),
       out: chan of (int, int, int, int, int, int, int))
{
	l, s: string;
	cont, x1, y1, x2, y2, x3, y3: int;

	(cont, l) = <-in;
	while(cont) {
		# We're cheating a little here by assuming the commas instead
		# of, e.g., using the Awk module, which has a decent chance of
		# being way faster.
		(x1, s) = str->toint(l, 10);
		(y1, s) = str->toint(s[1:], 10);
		(x2, s) = str->toint(s[1:], 10);
		(y2, s) = str->toint(s[1:], 10);
		(x3, s) = str->toint(s[1:], 10);
		(y3, s) = str->toint(s[1:], 10);

		out <-= (1, x1, y1, x2, y2, x3, y3);
		(cont, l) = <-in;
	}

	out <-= (0, 0, 0, 0, 0, 0, 0);
}

# Reads from the file and sends strings to the output.
reader(out: chan of (int, string), fname: string)
{
	file: ref Iobuf;

	file = bufio->open(fname, bufio->OREAD);

	if(file == nil) {
		out <-= (0, nil);
		sys->fprint(stderr, "OOOOOOOOOOOOH SHIIIIIIIIIII-- %r\n");
		return;
	}

	s := file.gets('\n');
	while(s != "") {
		out <-= (1, s);
		s = file.gets('\n');
	}
	file.close();

	out <-= (0, nil);
}

init(ctxt: ref Draw->Context, argv: list of string)
{
	sys = load Sys Sys->PATH;
	bufio = load Bufio Bufio->PATH;
	str = load String String->PATH;

	stderr = sys->fildes(2);

	res := chan of int;
	checked := chan of int;
	parsed := chan of (int, int, int, int, int, int, int);
	readed := chan of (int, string);

	spawn reader(readed, tfile);
	spawn parser(readed, parsed);
	spawn checker(parsed, checked);
	spawn collector(checked, res);

	total := <- res;

	sys->print("%d\n", total);
}
