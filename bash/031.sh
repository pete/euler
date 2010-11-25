#!/usr/bin/env bash

# How many different ways can £2 be made using any number of coins?

# Best way I could figure to do the "200 -> 100 -> etc." in bash.
nextx() {
	if [ "$1" -eq 200 ]; then
		echo 100
	elif [ "$1" -eq 100 ]; then
		echo 50
	elif [ "$1" -eq 50 ]; then
		echo 20
	elif [ "$1" -eq 20 ]; then
		echo 10
	elif [ "$1" -eq 10 ]; then
		echo 5
	elif [ "$1" -eq 5 ]; then
		echo 2
	elif [ "$1" -eq 2 ]; then
		echo 1
	else
		exit $1
	fi
}

# This one takes two and a half minutes!  That won't do.
pb() {
	if [ "$2" -lt 0 -o -z "$1" ]; then
		echo 0
	elif [ "$1" -eq 1 ]; then
		echo 1
	else
		echo $(( $(pb $(nextx $1) $2) + $(pb $1 $(($2 - $1)) ) ))
	fi
}

pc1 () {
	echo 1;
}
pcc=200
while [ $pcc -ne 1 ]; do
	eval "pc$pcc () {
		if [ "'$'"1 -lt 0 ]; then echo 0
		else echo "'$'"(("'$'"(pc$(nextx $pcc) "'$'"1) + "'$'"(pc$pcc "'$'"(("'$'"1 - $pcc)))))
		fi
	}"
	pcc=$(nextx $pcc)
done

# Now, that's uniform and correct, but takes 1m34.663s.  If we use the
# closed-form solution for p5(n), then we can get a huge speed-up.  In fact, the
# correct solution takes 0m0.334s.  In bash!  This puts its speed above the
# Erlang version's, but the Erlang one certainly looks better.
pc5 () {
	# p[5](n) = round(((n+4)^2)/20)
	echo $(( ((($1 + 4) ** 2) + 10) / 20 ))
}

#time pb 200 200
time pc200 200
