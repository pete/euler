/*
	Find the value of d < 1000 for which 1/d contains the longest recurring cycle in
	its decimal fraction part.

	This looks like you should be able to solve it just by doing long division
	and filling in an array.  I think that solution would work fine, but that's
	not what I implemented.  Wikipedia provided a link to the OEIS:
	https://oeis.org/A003592 . This would probably work.  The little programs
	they provided knocked out numbers of the format 2^n+5^m, though.  Obviously,
	in base-10, those don't repeat.  And that got me thinking that any other
	number's period would be the same after we factor out the 2's and 5's,
	right?  So what about prime numbers?

	From a cursory glance at the numbers in the sequence (no need to pull the
	whole list, and I didn't want to accidentally see the answer), it was true
	that the longest periods were prime numbers, but not all the prime numbers:
	7, 17, 19, 23, 29, 47, 59, 61.  That's in the OEIS, too!
	https://oeis.org/A001913 . Unfortunately, at this point, I saw the answer
	and couldn't un-see it.  (Don't click the link unless you can un-see things.)
	So, it's hard to go with your gut once you know the answer.  
	But that sequence is named "Full reptend primes: primes with primitive root
	10".  There's apparently no computationally trivial way to calculate the
	primitive root, according to Wikipedia, and what we have is fast enough:
	we'll figure out the largest prime under 1,000 such that period(1/n)=n-1.

	I initially did it in C, but the algorithm for calculating the period
	produced numbers that exceeded the max for a long double(!).  So I thought
	I'd just throw Go at it instead of touching libgmp or implementing the
	long-division method, to see how Go was with bigints.

	After finishing this and submitting the answer, I looked at the forum and
	there was a hilariously simple version in C that puts this code to shame.

	2.05s for exprPeriod(), 1.73s if you call period(), which doesn't do any
	allocations in the loop.
*/


package main

import (
	"fmt"
	"math/big"
)

/*
	This started as more or less a transliteration of the Python code from
	https://oeis.org/A051626 . But it didn't work!  I played with it, suspecting
	that I was handling the doubles sloppily or something, but that was all
	fine.  So I tried running the Python code and...it didn't terminate.  Even
	for 7.  This is what you get for using random code from the internet without
	understanding it.

	But it did work in Ruby, although it took about three seconds to finish for
	the number that turned out to be the answer.  I shoved a bunch of printf()s
	all over the C code, and eventually discovered that the problem was that we
	started exceeding the capacity for "long double" some time around 23.

	I probably could have just finished up the solution in Ruby, but that would
	have been no fun at all.  Limbo would have worked, but I only have one Go
	solution here, so I decided to go with that.

	Of the implementations of this algorithm in Ruby, C, Python, and Go, the Go
	one was ugliest, but that tends to be the case when arbitrary-precision ints
	are not builtin.  For efficiency reasons, "math/big" implements everything
	as destructive operations, and this contributed to the ugliness.

	This would probably have been much faster and slightly less ugly but
	slightly more opaque had I not insisted on keeping the expressions intact
	rather than restructuring it to fit a more natural style for "math/big".
*/
func exprPeriod(n int64) int64 {
	bn := big.NewInt(n)
	b0 := big.NewInt(0)
	b1 := big.NewInt(1)
	b10 := big.NewInt(10)

	lpow := big.NewInt(1)
	mpow := new(big.Int)

	for {
		for mpow.Sub(lpow, b1); mpow.Cmp(b0) >= 0; mpow.Sub(mpow, b1) {
			mod := new(big.Int).Mod(
				new(big.Int).Sub(
					new(big.Int).Exp(b10, lpow, nil),
					new(big.Int).Exp(b10, mpow, nil)),
				bn)
			if mod.Cmp(b0) == 0 {
				lpow.Sub(lpow, mpow)
				return lpow.Int64()
			}
		}
		lpow.Add(lpow, b1)
	}
}

func period(n int64) int64 {
	bn := big.NewInt(n)
	b0 := big.NewInt(0)
	b1 := big.NewInt(1)
	b10 := big.NewInt(10)

	lpow := big.NewInt(1)
	mpow := new(big.Int)
	mod := new(big.Int)
	t := new(big.Int)

	for {
		for mpow.Sub(lpow, b1); mpow.Cmp(b0) >= 0; mpow.Sub(mpow, b1) {
			mod.Exp(b10, lpow, nil)
			t.Exp(b10, mpow, nil)
			mod.Sub(mod, t)
			mod.Mod(mod, bn)
			if mod.Cmp(b0) == 0 {
				lpow.Sub(lpow, mpow)
				return lpow.Int64()
			}
		}
		lpow.Add(lpow, b1)
	}
}

// This main() is really just exactly the C, line for line.
func main() {
	// First, a trivial prime sieve.  No need to care much: 1000 is small and we
	// won't ever hit the lower bounds.
	sieve := [1000]byte{}
	for i := 0; i < 1000; i++ {
		sieve[i] = byte(i & 1)
	}
	for i := 3; i < 32; i++ {
		for j := 2; i * j < 1000; j++ {
			sieve[i * j] = 0
		}
	}

	for i := int64(999); i > 0; i -= 2 {
		if sieve[i] != 0 && (period(i) == i - 1) {
			fmt.Printf("%v\n", i)
			return
		}
	}
	panic("This should not happen!")
}
