// Find the sum of all numbers, less than one million, which are palindromic in
// base 10 and base 2.

// I did this mainly to see if a rough translation of the Pez version would look
// any clearer.  bitp_even and bitp_odd look worse to me, although the
// palindrome_p function is much nicer (the Pez version goes to the trouble of
// producing a reversed string and then calling strcmp).  It goes without
// saying, I'm sure, that the C version is faster.  (0.00029s in C vs. 0.004369s
// in Pez.)

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>

#define MAX_DIGITS 6 // number of digits in 999,471.

int palindrome_p(int n)
{
	char decstr[MAX_DIGITS + 1];
	int i, ndigits;
	ndigits = snprintf(decstr, MAX_DIGITS + 1, "%d", n) - 1;
	// We really don't care about the middle digit, if any.
	for(i = 0; i <= ndigits / 2; i++) {
		if(decstr[i] != decstr[ndigits - i])
			return 0;
	}
	return 1;
}

int n_bits(int n)
{
	int i = 0;

	while(n) {
		i++;
		n >>= 1;
	}

	return i;
}

int bitp_even(int n)
{
	int i, bits;

	bits = n_bits(n);
	n <<= bits;

	for(i = bits - 1; i >= 0; i--) {
		n |= ((n & (1 << (i + bits))) != 0) << (bits - i - 1);
	}

	return n;
}

int bitp_odd(int n)
{
	int i, bits;

	bits = n_bits(n) - 1;
	n <<= bits;

	for(i = bits - 1; i >= 0; i--) {
		n |= ((n & (1 << (i + bits + 1))) != 0) << (bits - i - 1);
	}

	return n;
}

/*
   Had to do some benchmark stuff internally, because the time command does not
   spit out results with enough precision to measure this program.
*/
inline double ftime()
{
	struct timeval tv;
	double d;

	gettimeofday(&tv, 0);
	d = (double)tv.tv_sec + (double)tv.tv_usec / 1000000.0;

	return d;
}

void print_result(double t, long r)
{
	t = ftime() - t;
	printf("%ld (%0.05f seconds)\n", r, t);
}

int main(int argc, char *argv[])
{
	double ft;
	int n, t, sum = 0;

	ft = ftime();

	// Largest binary palindrome under 1,000,000 (0xf4240) is 999,471
	// (0xf402f), the first (binary) half of which is 976 (0x3d0).
	for(n = 1; n <= 0x3d0; n++) {
		t = bitp_even(n);
		if(palindrome_p(t))
			sum += t;

		t = bitp_odd(n);
		if(palindrome_p(t))
			sum += t;
	}

	print_result(ft, sum);

	return 0;
}
