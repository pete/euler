#!/dis/sh
# Analyse the file so as to determine the shortest possible secret passcode of
# unknown length.

# Did this one by hand, but here are some solutions.

load std regex mpexpr

# BEHOLD!
# 9684.74user 84.49system 2:42:50elapsed 99%CPU
fn ridiculous_edition {
	sed 's/(.)/\1.*/g' | {
		getlines { rxs = $rxs $line }
		i = 1
		done = 0
		while {~ $done 0} {
			done = 1
			for rx in $rxs {
				or {match $rx $i} {done = 0; raise break}
			}
			i = ${expr $i 1 +}
		}
		echo $i
	}
}


# Although it does rely on there being no dups, it solves the problem as stated
# in 0.02s.  I wrote it while letting ridiculous_edition run, and was done
# writing it before ridiculous_edition finished.  I let ridiculous_edition run
# overnight, and was a bit disappointed that it didn't even take three hours.  I
# think if you remove the break, you could get the time up way higher.
# This version splits the number into digits, and for each digit, tries to find
# out if it comes next in the code by seeing if it is first in all of the
# remaining attempts.
fn sensible_edition {
	getlines { attempts = $attempts $line }
	digits = `{echo $attempts | sed 's/(.)/\1\n/g' | sort | uniq}
	code = ''
	while {! no $digits} {
		nxd = ()
		for d in $digits {
			rescue invalid {nxd = $nxd $d} {
				for a in $attempts {
					and ({~ $a '*'^$d^'*'}
					     {! ~ $a $d^'*'}
					     {raise invalid})
				}
				code = $code^$d
				attempts = ${re s '^'^$d '' $attempts}
			}
		}
		digits = $nxd
	}
	echo $code
}

sensible_edition
