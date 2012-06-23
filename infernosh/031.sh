#!/dis/sh
# How many different ways can £2 be made using any number of coins?
# 0.11s without JIT, 0.04s with

load std expr

xs = 200 100 50 20 10 5 2 1

# 15s on a speedy box.  Let's try something a little speedier!
subfn pn {
	#args = $*; echo ${join , $args}
	(n x nx) := $*

	if {no $x} {
		result = 0
	} {~ $x 1} {
		result = 1
	} {~ ${expr $n 0 '<'} 1} {
		result = 0
	} {
		result = ${expr ${pn $n $nx} ${pn ${expr $n $x -} $x $nx} +}
	}
}

# 7s, much better than 15s:
for i in ${expr 1 ${expr $#xs 1 -} seq} {
	xc := ${index $i $xs}
	xn := ${index ${expr $i 1 +} $xs}
	# There are a few hoops to jump through if you want a function named
	# dynamically, with a body that is generated dynamically:
	${parse '{subfn p'^$xc^'{
			n := $1
			if {~ ${expr $n 0 ''<''} 1} {
				result = 0
			} {
				result = ${expr ${p'^$xn^' $n} ${p'^$xc^' ${expr $n '^$xc^' -}} +}
			}
		}}'
	}
}
subfn p1 { result = 1 }

# Adding this definition cuts the execution time down to 0.05s:
subfn p5 {
	n := $1
	# p5 = ((n+4)^2 + 10) / 20
	np4 := ${expr $n 4 +}
	result = ${expr $np4 $np4 '*' 10 + 20 /}
}

a = $1
if {no $a} {a = 200}
# echo ${pn $a $xs} # 15s
echo ${p200 $a} # 0.05s
