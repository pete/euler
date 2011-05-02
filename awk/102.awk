#! /usr/bin/awk -f

# Find the number of triangles for which the interior contains the origin.

# 0m0.009s.
# Things I learned today:
# 	* awk is possibly the fastest interpreter installed on my machine
# 	* awk does not let you return arrays as values from functions.
# 	* awk is very fun.
# I think I might start doing all of the PE solutions that give you big CSVs in
# awk.  It is good times.


BEGIN { count=0 }

function dot_prod(p1x, p1y, p2x, p2y) {
	return p1x * p2x + p1y * p2y
}

function triangle_contains_origin(ax, ay, bx, by, cx, cy) {
	v0x = cx - ax
	v0y = cy - ay
	v1x = bx - ax
	v1y = by - ay
	v2x = -ax
	v2y = -ay

	d00 = dot_prod(v0x, v0y, v0x, v0y)
	d01 = dot_prod(v0x, v0y, v1x, v1y)
	d02 = dot_prod(v0x, v0y, v2x, v2y)
	d11 = dot_prod(v1x, v1y, v1x, v1y)
	d12 = dot_prod(v1x, v1y, v2x, v2y)

	#print ax, ay, bx, by, cx, cy
	#print d00, d01, d02, d11, d12
	#print "--"

	inv = 1 / (d00 * d11 - d01 * d01)
	u = (d11 * d02 - d01 * d12) * inv
	v = (d00 * d12 - d01 * d02) * inv

	# printf("[%d,%d],[%d,%d],[%d,%d] -> [%d,%d,%d,%d,%d]\n"
	#	"\t(%g / %g) => %d\n",
	#	ax, ay, bx, by, cx, cy,
	#	d00, d01, d02, d11, d12,
	#	u, v, (((u > 0) && (v > 0)) && ((u + v) < 1) ? 1 : 0)

	return(((u > 0) && (v > 0)) && ((u + v) < 1) ? 1 : 0)
}

{ count += triangle_contains_origin($1, $2, $3, $4, $5, $6) }

END { print count }
