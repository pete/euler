#!/dis/sh

# Find the maximum total from the top to the bottom of the triangle.

# 1.2s without JIT, 0.5s with.  Not going to beat the awk or Limbo solutions,
# but not shabby overall.

load std expr

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
		#if {ntest ${expr $x $y '>'}} {
		#	cur = $cur ${expr $n $x +} 
		#} {
		#	cur = $cur ${expr $n $y +}
		#}
		# This is not much faster:
		#cur = $cur ${expr $y $x '>' 1 - $x and $x $y '>' 1 - $y and +}
		# ...but *this* cuts 1/6 of the execution time!
		cur = $cur ${expr $y $x '<' not $x '*' $x $y '<' not $y '*' +}
		x = $y
	}
	prev = $cur
}
echo $cur
