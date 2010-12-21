#!/usr/bin/env bash

# Find the 10,001st prime.

# Under a second!

seq $((2 ** 31)) | \
	xargs -P4 -n20 factor 2>/dev/null | \
	grep -E '^([1-9][0-9]*): \1$' | \
	head -n 10081 | \
	sort -n  | \
	head -n 10001 | \
	tail -n 1 | \
	sed 's/:.*//'
