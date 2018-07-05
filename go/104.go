/*
	Given that F[k] is the first Fibonacci number for which the first nine
	digits AND the last nine digits are 1-9 pandigital, find k.

	All right, I'm going to brute-force this as a first try, and if that
	finishes before I come up with something smarter, then you'll see the dumb
	version here.
	
	17.12s.
*/


package main

import (
	"fmt"
	"math/big"
)

func isPD(s string) bool {
	if len(s) < 9 {
		return false
	}
	n := 0
	for i := 0; i < 9; i++ {
		n |= 1 << (s[i]-('0'+1))
	}
	return n == 0x1ff
}

func main() {
	p := big.NewInt(1)	// Prev
	c := big.NewInt(1)	// Current

	for i := 3; i <= 2749; i++ {
		p.Add(c, p)
		c, p = p, c
	}

	a := big.NewInt(2749)
	b1 := big.NewInt(1)
	bm := big.NewInt(1000000000)
	m := new(big.Int)

	// This was a sanity check to avoid an off-by-one and to see if it took
	// a long time.  It caught the off-by-one, but it didn't take long.
	fmt.Printf("Starting the heavy bit now.  (isPD(m) = %v)\n", isPD(c.String()))

	for {
		p.Add(c, p)
		c, p = p, c
		a.Add(a, b1)

		// It was a speed hack to check the last nine digits without allocating
		// a big string each iteration.
		m.Mod(c, bm)
		if isPD(m.String()) && isPD(c.String()) {
			fmt.Printf("Looks like we have a winner:  %v\n", a.String())
			return
		}
	}
}
