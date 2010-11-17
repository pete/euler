#!/bin/bash

# It'll take forever, but won't burn your CPU!
# real    7m31.359s
# user    0m10.763s
# sys     0m40.004s
#
# Yeah, I hope you weren't expecting me to explain why, because I'm not sure.

(echo 1 1; for i in $(seq 2 100000); do 
	eval "echo $(factor $i |
		sed 's/.*: */$((/;s/\([1-9][0-9]*\) \(\1\(  *\|$\)\)*/\1 /g;s/ *$/))/;s/  */*/g') $i"
done) | sort -n | cut -d\  -f2 | head -n 9999 | tail -n 1
