#!/usr/bin/awk -f

BEGIN {
	print "\tt := array[] of {"
}
NF {
	sub(/^ */, "")
	gsub(/ 0/, " ")
	gsub(/  */, ",")
	print "\t\tarray[] of {" $0 "},"
}
END { print "\t};" }
