/*
	How many numbers below fifty million can be expressed as the sum of a prime
	square, prime cube, and prime fourth power?

	This one was easy to brute-force, and I just recycled the previous answer.

	0.26s.
*/

package main

import (
	"fmt"
	"math"
)

// The sieve is overkill, but I had it around from doing #111.
const nmax = 50000000
const pmax = 7078 // 7079² > 50,000,000.
var sieve []byte

func main() {
	hits := make(map[int64]bool)

	initSieve()
	cs := [3]int64{2, 2, 2}

	nx := func() bool {
		cs[2] = nextPrime(cs[2])
		if cs[2] * cs[2] * cs[2] * cs[2] >= nmax {
			cs[2] = 2
			cs[1] = nextPrime(cs[1])
		}
		if cs[1] * cs[1] * cs[1] >= nmax {
			cs[1] = 2
			cs[0] = nextPrime(cs[0])
		}
		if cs[0] == 0 || cs[0] * cs[0] >= nmax {
			return false
		}
		return true
	}

	hits[28] = true
	for nx() {
		res := cs[0] * cs[0] +
			cs[1] * cs[1] * cs[1] +
			cs[2] * cs[2] * cs[2] * cs[2]
		if res < nmax {
			hits[res] = true
		}
	}

	fmt.Printf("%d\n", len(hits))
}

func initSieve() {
	sieve = make([]byte, p2i(pmax|1))
	max := int64(math.Sqrt(float64(len(sieve) * 2 + 3)))
	for i := int64(3); i < max; i = nextPrime(i) {
		if i == 0 {
			return
		}
		for j := i * 3; j < pmax; j += i * 2 {
			sieve[p2i(j)] = 1
		}
	}
}

func p2i(i int64) int {
	return int((i - 3) >> 1)
}

func i2p(i int) int64 {
	return int64((i << 1) + 3)
}

func nextPrime(i int64) int64 {
	if i == 2 {
		return 3
	}
	for j := p2i(i) + 1; j < len(sieve); j++ {
		if sieve[j] == 0 {
			return i2p(j)
		}
	}
	return 0
}

func prevPrime(i int64) int64 {
	if i == 3 {
		return 2
	}
	if i == 2 {
		return 0
	}
	for j := p2i(i) - 1; j >= 0; j-- {
		if sieve[j] == 0 {
			return i2p(j)
		}
	}
	return 0
}
