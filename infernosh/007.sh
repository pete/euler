#!/dis/sh
# What is the 10,001st prime number?
# 0.17s

# Density of primes under a million is roughly 0.072, so a reasonable upper
# bound is 138168:
math/primes 1 138168 | sed -n '10001{p;q}'
