#include <stdio.h>
#include <stdlib.h>

// F(n) = 4 * F(n - 3) + F(n - 6)
long sum_even_fibs(long limit)
{
	long sum = 2, a = 2, b = 8, tmp;

	while(b <= limit) {
		sum += b;
		tmp = a + 4 * b;
		a = b;
		b = tmp;
	}
	return sum;
}

long which_limit(int argc, char **argv)
{
	long limit;

	if(!argc)
		return 4000000;

	limit = atol(argv[0]);
	if(!limit)
		return 4000000;
	return limit;
}

int main(int argc, char **argv)
{
	long limit;
	limit = which_limit(argc - 1, argv + 1);
	printf("%ld\n", sum_even_fibs(limit));
	return 0;
}
