// Find the unique positive integer whose square has the form
// 1_2_3_4_5_6_7_8_9_0, where each “_” is a single digit.

// Note that this'll only produce a valid answer on a machine where longs are
// 64 bits wide.  This is not a clever solution.  It takes only about four
// seconds.

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/time.h>
#include <math.h>

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

long fill(int digits[9])
{
	long f =
		digits[0] * 10 + 
		digits[1] * 1000 + 
		digits[2] * 100000 + 
		digits[3] * 10000000 + 
		digits[4] * 1000000000 + 
		digits[5] * 100000000000 + 
		digits[6] * 10000000000000 + 
		digits[7] * 1000000000000000 + 
		10203040506070809;
	return f;
}

void nextd(int *digits)
{
	if(*digits == -1)
		abort();

	(*digits)++;
	if(*digits > 9) {
		*digits = 0;
		nextd(digits + 1);
	}
}

int check(long n, long *r)
{
	long c;

	c = (long)floorl(sqrtl((long double)n));

	if(c * c == n) {
		*r = c;
		return 1;
	}

	return 0;
}

int main(int argc, char *argv[])
{
	double t;
	int digits[9] = {0, 0, 0, 0, 0, 0, 0, 0, -1};
	long r;

	t = ftime();

	while(!check(fill(digits), &r)) {
		nextd(digits);
	}

	r *= 10;
	print_result(t, r);

	return 0;
}
