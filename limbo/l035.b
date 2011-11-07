# How many circular primes are there below one million?

# So, first we want to sieve the primes under ten million, and whenever we find
# one, we send it through a channel to the thread that checks for primality of
# circular permutations, and whenever it finds one of those, it sends it back to
# the main thread.  Totally brute force, 2.23s interpreted, 1.06s compiled.

implement L035;

include "sys.m"; sys: Sys; stderr: ref sys->FD;
include "draw.m";
include "string.m"; str: String;

L035: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

smax: con 10000000;
ssize: con smax / 2;
sieve: array of byte;

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
	return sieve[(n / 2) - 1] == byte 0;
}

sieve_prime(n: int)
{
	# I get the impression that if I were not so lazy, a lot of math could
	# be eliminated here.  But this isn't the slow part; that's
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

is_circular(n: int): int
{
	if(n < 10)
		return 1;

	i: int;
	s := sys->sprint("%d", n);

	for(i = 0; i < len s; i++)
		if(((int s[i] & 1) == 0) || s[i] == '5')
			return 0;
	
	# This is kind of clever; instead of figuring out how to rotate it, I
	# just concatenated the string with itself and took substrings.
	# Probably not any faster, but it was fun.
	ss := s + s;

	for(i = 0; i < len s; i++) {
		n := int ss[i:(i + len s)];
		if(!is_prime(n))
			return 0;
	}
	
	return 1;
}

send_circular(out: chan of int, primes: chan of int)
{
	n: int;
	while(n = <-primes) {
		if(is_circular(n)) {
			out <-= n;
		}
	}

	out <-= 0;
}

init(ctxt: ref Draw->Context, argv: list of string)
{
	sys = load Sys Sys->PATH;
	stderr = sys->fildes(2);
	str = load String String->PATH;

	total := 1; # Because we leave 2 out of the calculations.
	prime_chan := chan of int;
	circular := chan of int;
	n: int;

	spawn sieve_primes(prime_chan);
	spawn send_circular(circular, prime_chan);

	while(n = <-circular)
		total++;

	sys->print("%d\n", total);
}
