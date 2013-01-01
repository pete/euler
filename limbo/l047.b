# Find the first four consecutive integers to have four distinct primes factors.
# What is the first of these numbers?

# We sieve primes, count divisors, and then when we hit 4 4's in a row, print
# the first of them and quit.  The max for the sieve was actually a guess, and
# happened to solve the problem in a second.  Someone in the forum pointed out
# that this was http://oeis.org/A075044 . Personal disappointment.

implement L047;

include "sys.m"; sys: Sys;
include "draw.m";

L047: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

smax: con 1000000;
ssize: con smax / 2;
sieve: array of byte;
primes: array of int;

init(nil: ref Draw->Context, args: list of string)
{
	sys = load Sys Sys->PATH;

	tryfor := 4;
	if(args != nil && tl args != nil) {
		i := int hd tl args;
		if(i < 2)
			raise "fail:usage";
		tryfor = i;
	}

	prime_chan := chan of int;
	donec := chan of int;

	spawn sieve_primes(prime_chan);
	spawn collect_primes(donec, prime_chan);
	<-donec;

	found := 0;

	for(i := 6; i < smax; i++) {
		cur := omega(i);

		if(cur == tryfor) {
			found++;
			if(found == tryfor) {
				sys->print("%d\n", i + 1 - tryfor);
				exit;
			}
		} else {
			found = 0;
		}
	}
}

omega(n: int): int
{
	c := t := 0;

	if(is_prime(n))
		return 1;

	for(i := 0; n > 1; i++) {
		t = 0;
		while((n % primes[i]) == 0) {
			n /= primes[i];
			t = 1;
		}
		if(t)
			c++;
	}

	return c;
}

i2so(i: int): int
{
	return (i / 2) - 1;
}

so2i(so: int): int
{
	return 1 + ((so + 1) * 2);
}

is_prime(n: int): int
{
	case n {
	0 => raise "fail";
	2 or 3 or 5 or 7 => return 1;
	1 or 4 or 6 or 8 => return 0;
	}
	if(!(n&1))
		return 0;
	return sieve[(n / 2) - 1] == byte 0;
}

sieve_prime(n: int)
{
	# I get the impression that if I were not so lazy, a lot of math could
	# be eliminated here.
	# is_circular().
	d := n * 2;
	for(n = 3 * n; n < smax; n += d)
		sieve[(n / 2) - 1] = byte 1;
}

sieve_primes(out: chan of int)
{
	sieve = array[ssize] of { * => byte 0 };

	for(i := 3; i < smax; i += 2) {
		if(is_prime(i)) {
			out <-= i;
			sieve_prime(i);
		}
	}

	out <-= 0;
}

collect_primes(d: chan of int, p: chan of int)
{
	l := 2 :: nil;
	while((n := <-p) != 0) {
		l = n :: l;
	}

	primes = array[len l + 1] of int;
	for(i := len l - 1; i >= 0; i--) {
		primes[i] = hd l;
		l = tl l;
	}

	d <-= 0;
}
