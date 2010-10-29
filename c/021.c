#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

long sigma(long n)
{
	long total = 1;
	int i = floor(sqrt(n));

	while(i > 1) {
		if((n % i) == 0)
			total += i + (n / i);
		i--;
	}
	return total;
}

long *sigmas;

long m_sigma(long n)
{
	if(!sigmas[n])
		sigmas[n] = sigma(n);
	return sigmas[n];
}

long sum_amicable(long limit)
{
	long amicable_sum = 0, i, si;
	for(i = 1; i < limit; i++) {
		si = m_sigma(i);
		if(si < i && m_sigma(si) == i)
			amicable_sum += i + si;
	}
	return amicable_sum;
}

int main(int argc, char *argv[])
{
	long limit;
	if(argv[1])
		limit = atol(argv[1]);
	else
		limit = 10000;

	sigmas = malloc(limit * sizeof(long));
	if(!sigmas)
		return 1;
	memset(sigmas, limit, sizeof(long));

	printf("%ld\n", sum_amicable(limit));

	return 0;
}
