#!/dis/sh
# Find the sum of all primes under 2,000,000.
# 3.012s
load expr
echo ${expr `{math/primes 1 2000000} + rep}
