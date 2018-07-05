/*
	For each digit, find the sum of the ten-digit primes with the maximal
	value for that digit.

	All right, so, log₂(9999999999) ≈ 33.2.  There are 466,116,823 primes
	under 1e10.  log₂(466116823) ≈ 28.8.  This means that the answer fits
	comfortably in 64 bits.

	If we're gonna sieve the easy way, 1e10/2 bytes is 4.6GB.  Worst-case
	scenario on this machine is that that makes the OOM-killer trash Firefox,
	likely case is that a lot of cache gets evicted.  Fine with me, I don't
	want to address individual bits.

	153s, 112s of which was initializing the sieve.  Since that's where all the
	overhead was, I tried various ways of parallelizing the sieve, but it's such
	a simple loop that it actually ran 2-3 times slower.  The rest of the
	problem (scanning and counting digits) is easy to parallelize, but since
	it's only about a quarter of the runtime, there's not much of a benefit.

	I ported it to C.  There is additional commentary there.
*/

package main

import (
	"fmt"
	"math"
)

var sieve []byte
const pmax = 10000000000

func main() {
	initSieve() // This bit takes about two minutes.

	// I had suspected this part was unnecessary, because I had expected the
	// maximum number of 0's to be eight and for it to be nine for the other
	// digits, but that was not true.
	maxima := [10]int{}
	for i := nextPrime((pmax / 10) - 1); i < pmax && i > 0; i = nextPrime(i) {
		cd := dcount(i)
		for j := 0; j < 10; j++ {
			if cd[j] > maxima[j] {
				maxima[j] = cd[j]
			}
		}
	}
	fmt.Printf("%v\n", maxima)

	sum := int64(0)
	for i := nextPrime((pmax / 10) - 1); i < pmax && i > 0; i = nextPrime(i) {
		cd := dcount(i)
		for j := 0; j < 10; j++ {
			if cd[j] == maxima[j] {
				sum += i
			}
		}
	}

	fmt.Printf("%v\n", sum)
}

func dcount(i int64) [10]int {
	r := [10]int{}
	for i != 0 {
		m := i % 10
		r[m]++
		i /= 10
	}
	return r
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
	if i & 1 == 0 || i < 0 {
		panic("NO " + fmt.Sprintf("%d", i))
	}
	return int((i - 3) >> 1)
}

func i2p(i int) int64 {
	return int64((i << 1) + 3)
}

func nextPrime(i int64) int64 {
	for j := p2i(i) + 1; j < len(sieve); j++ {
		if sieve[j] == 0 {
			return i2p(j)
		}
	}
	return 0
}
