#!/usr/bin/awk -f

# Having generated a chunk of the Limbo solutions using awk, I thought I'd give
# writing an awk solution a shot.

# Still too fast to be fun.  (6ms in mawk, 13ms in gawk, 13ms in Busybox awk)

{ a[NR] = $0; l = NR }
END {
	split(a[l], prev, / /)
	for(i = l - 1; i; i--) {
		split(a[i], cur, / /)
		for(j in cur) {
			if(prev[j] > prev[j+1])
				cur[j] = cur[j] + prev[j]
			else
				cur[j] = cur[j] + prev[j+1]
		}
		delete prev
		for(j in cur) { prev[j] = cur[j] }
	}
	print cur[1]
}
