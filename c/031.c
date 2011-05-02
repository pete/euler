// How many different ways can £2 be made using any number of coins?
#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>

// I did three versions in here:  a memoizing version, a version with a jump
// table, and a version that uses functions generated to compute a solution for
// a specific value of X.  Running all three of them in C takes less time than
// running any of the individual solutions in any of the other languages.  C is
// great for math, and it reads about as well as the solutions in the other
// languages in this repo.

#define MAX_X 200
#define MAX_N 200

// I forget about globals, but I recall the spec saying that static globals are
// implicitly zero'd.  Either way, we're wasting some space, but not too much
// for the bounds of the problem.
static long memo[(MAX_X + 1) * (MAX_N + 1)];
static char nextp[MAX_X + 1];

long p(long x, long n)
{
	if(x == 1)
		return x;

	if(n < 0)
		return 0;

	if(!memo[(x * MAX_N) + n])
		memo[(x * MAX_N) + n] = p(nextp[x], n) + p(x, n - x);

	return memo[(x * MAX_N) + n];
}

#define RNEXTX(x, next_x) case x: return(p_prime(next_x, n) + p_prime(x, n - x))

long p_prime(long x, long n)
{
	if(n < 0)
		return 0;
	switch(x) {
	case 1: return 1;
	RNEXTX(2, 1);
	RNEXTX(5, 2);
	RNEXTX(10, 5);
	RNEXTX(20, 10);
	RNEXTX(50, 20);
	RNEXTX(100, 50);
	RNEXTX(200, 100);
	}
}

// Oh, C preprocessor, you are a fancy thing of the ages.
#define px(x, next_x) long p##x(long n) { \
	if(n < 0) return 0; \
	return p##next_x(n) + p##x(n - x); \
}

long p1(long n) { return 1; }
px(2, 1)
px(5, 2)
px(10, 5)
px(20, 10)
px(50, 20)
px(100, 50)
px(200, 100)

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

void print_result(double t, long r, char *name)
{
	t = ftime() - t;
	printf("%ld (%0.05fs for %s version)\n", r, t, name);
}

int main(int argc, char *argv[])
{
	double t;
	long r;

	// Solution 1 needs a little initialization.  This was simpler than
	// typing out (or generating) the entire nextp array as an initializer.
	nextp[200] = 100;
	nextp[100] = 50;
	nextp[50] = 20;
	nextp[20] = 10;
	nextp[10] = 5;
	nextp[5] = 2;
	nextp[2] = 1;

	t = ftime();
	r = p(200, 200);
	print_result(t, r, "memoizing");

	t = ftime();
	r = p_prime(200, 200);
	print_result(t, r, "switch/case");

	t = ftime();
	r = p200(200);
	print_result(t, r, "macro");

	return 0;
}
