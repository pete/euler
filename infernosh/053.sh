#!/dis/sh
# Timings are littered throughout; I realized, though, that I had been running
# without JIT, so they are faster with JIT enabled.
load std mpexpr

# This version does no caching.  The program takes about 100s to run as a
# result.
subfn fac {
	(n s) := $1 1
	while {! ~ $n 0} {
		s = ${expr $s $n '*'}
		n = ${expr $n 1 -}
	}
	result = $s
}

fcache = 1
subfn fac {
	(n i) := $1 1
	and {no ${index $n $fcache}} {
		r := ${expr $n ${fac ${expr $n 1 -}} '*'}
		fcache = $fcache $r
	}
	result = ${index $n $fcache}
}
# 10 seconds with a cache.

{} ${fac 100}
# 14(!) seconds if we prefill the cache first.
subfn fac { n := $1; result = ${index $n $fcache} }
# 8.0 seconds if we replace the caching version with just a cache lookup.

subfn c {
	(n r) := $1 $2
	nf := ${fac $n}
	rf := ${fac $r}
	n_rf := ${fac ${expr $n $r -}}
	result = ${expr $nf $rf $n_rf '*' /}
}

subfn c {
	(n r) := $1 $2
	nf := ${index $n $fcache}
	rf := ${index $r $fcache}
	n_rf := ${index ${expr $n $r -} $fcache}
	result = ${expr $nf $rf $n_rf '*' /}
}
# 7.3s if we eliminate ${fac} from ${c} and just look at the cache directly.

# ...aaaand, I was apparently running the shell without JIT, so make that 2.0s.

subfn c {
	(n r) := $1 $2
	nf := ${index $n $fcache}
	rf := ${index $r $fcache}
	n_rf := ${index ${expr $n $r -} $fcache}
	result = ${expr $nf $rf $n_rf '*' /}
}

subfn rs_for_n {
	n := $1
	t := 0
	for r in ${expr 1 $n seq} {
		c = ${c $n $r}
		and {~ ${expr $c 1000000 '>'} 1} { t = ${expr $t 1 +} }
	}
	result = $t
}

total = 0

for i in ${expr 23 100 seq} {
	#echo -n Doing $i...
	total = ${expr ${rs_for_n $i} $total +}
	#echo Total now $total.
}
echo $total
