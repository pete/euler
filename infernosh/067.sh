#!/dis/sh

# Find the maximum total from the top to the bottom of the triangle.

# 1.2s without JIT, 0.56s with.  Not going to beat the awk or Limbo solutions,
# but not shabby overall.

load std expr

# It adds 0.04s, but it's worth it to not have to wrap the line.
fn addmax {
	cur = $cur ${expr $y $x '<=' not $x '*' $x $y '<' not $y '*' + $n +}
}

# tac(1)
getlines { lines = $line $lines }

(prev lines) = $lines
prev = ${unquote $prev}
for l in $lines {
	l = ${unquote $l}
	i = 1
	cur = ()
	(x prev) = $prev
	for n in $l {
		(y prev) = $prev
		addmax
		x = $y
	}
	prev = $cur
}
echo $cur
