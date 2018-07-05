// How many different ways can £2 be made using any number of coins?

// First actual Go program I have written.  May not look right.  0m0.008s

package main

import (
	"fmt"
)

var m map[int]int

func main() {
	m = map[int]int {
		200: 100,
		100: 50,
		50: 20,
		20: 10,
		10: 5,
		5: 2,
		2: 1,
		1: 0,
	}

	fmt.Printf("%d\n", pmap(200, 200))
}

func pmap(x int, n int) int {
	if n < 0 {
		return 0
	}
	if x == 1 {
		return 1
	}
	return(pmap(m[x], n) + pmap(x, n - x))
}
