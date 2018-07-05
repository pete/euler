/*
	For each digit, find the sum of the ten-digit primes with the maximal
	value for that digit.

	It didn't require any big ints (see comments in the Go source), so I thought
	I'd see how the C version compared to the Go version.

	The Go version took about 150s.  The C version varied wildly:
		· 106s (gcc -O3)
		· 109s (clang -O3)
		· 153s (Go version)
		· 223s (gcc -Os)

	For fun, I sprinkled "static inline" about the place, and this
	(predictably) made no difference.  tinycc wouldn't compile it until
	I took out the C99-style inline decls, and then it segfaulted in
	init_sieve().  (This is an old version of TCC, though.)  I suspect
	the reason the -Os version was so slow is that even at -O3, the whole
	program still fits in the CPU cache and the majority of the RAM traffic
	is hammering the sieve anyway.

	Go's performance was all right!  It took a little more memory than the C
	version, though I suspect this was due to bookkeeping; C doesn't check array
	boundaries for you.  (≈200MB overhead is a drop in the bucket for a program
	that wants ≈4.6GB.)  I think the C version reads better, but it was
	certainly easier to test out parallel versions of the sieve in Go than it
	would be to restructure this program around pthreads.
*/

#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stdint.h>

#define PMAX 10000000000
#define PMAX_SQRT 100000
#define SSZ PMAX/2

static char sieve[SSZ];

static inline int64_t p2i(int64_t i)
{
	if(!(i & 1) || i < 0)
		abort();
	return (i - 3)>>1;
}

static inline int64_t i2p(int64_t i)
{
	return (i<<1) + 3;
}

static inline int64_t next_prime(int64_t i)
{
	int64_t j;
	for(j = p2i(i) + 1; j < SSZ; j++)
		if(!sieve[j])
			return i2p(j);
	return 0;
}

static void init_sieve()
{
	int64_t i, j;
	for(i = 3; i && i < PMAX_SQRT; i = next_prime(i)) {
		for(j = i * 3; j < PMAX; j += i * 2) {
			sieve[p2i(j)] = 1;
		}
	}
}

static void dcount(int64_t i, char *c)
{
	int m, j;
	for(j = 0; j < 10; j++)
		c[j] = 0;
	while(i > 0) {
		m = i % 10;
		i /= 10;
		c[m]++;
	}
}

int main(int argc, char **argv)
{
	char maxima[10];
	char dc[10];
	int64_t i, sum = 0;
	int j;
	char c;

	for(i = 0; i < 10; i++)
		maxima[i] = 0;

	init_sieve();
	for(i = next_prime((PMAX/10)-1); i < PMAX && i > 0; i = next_prime(i)) {
		dcount(i, dc);
		for(j = 0; j < 10; j++)
			if(dc[j] > maxima[j])
				maxima[j] = dc[j];
	}
	for(j = 0; j < 10; j++) {
		c = j == 9 ? '\n' : ',';
		printf("%d%c", maxima[j], c);
	}

	for(i = next_prime((PMAX/10)-1); i < PMAX && i > 0; i = next_prime(i)) {
		dcount(i, dc);
		for(j =  0; j < 10; j++)
			if(dc[j] == maxima[j])
				sum += i;
	}

	printf("%ld\n", sum);
	return 0;
}
