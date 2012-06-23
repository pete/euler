# Find the maximum total from the top to the bottom of the triangle.
#
# This one's a little annoying, due to copypasta.  To turn a triangle into an
# array, I used some awk:
#  BEGIN { print "\tt := array[] of {" }
#  NF {sub(/^ */, ""); gsub(/  */, ", "); print "\t\tarray[] of {" $0 "},"}
#  END { print "\t};" }
# I put the code here mainly because the problem warns of an even larger
# triangle, and I don't want to have to rewrite it.

implement L018;

include "sys.m"; sys: Sys;
include "draw.m";

L018: module {
	init: fn(ctxt: ref Draw->Context, argv: list of string);
};

init(nil: ref Draw->Context, nil: list of string)
{
	sys = load Sys Sys->PATH;

	t := array[] of {
		array[] of {75},
		array[] of {95, 64},
		array[] of {17, 47, 82},
		array[] of {18, 35, 87, 10},
		array[] of {20, 04, 82, 47, 65},
		array[] of {19, 01, 23, 75, 03, 34},
		array[] of {88, 02, 77, 73, 07, 63, 67},
		array[] of {99, 65, 04, 28, 06, 16, 70, 92},
		array[] of {41, 41, 26, 56, 83, 40, 80, 70, 33},
		array[] of {41, 48, 72, 33, 47, 32, 37, 16, 94, 29},
		array[] of {53, 71, 44, 65, 25, 43, 91, 52, 97, 51, 14},
		array[] of {70, 11, 33, 28, 77, 73, 17, 78, 39, 68, 17, 57},
		array[] of {91, 71, 52, 38, 17, 14, 91, 43, 58, 50, 27, 29, 48},
		array[] of {63, 66, 04, 68, 89, 53, 67, 30, 73, 16, 69, 87, 40, 31},
		array[] of {04, 62, 98, 27, 23, 09, 70, 98, 73, 93, 38, 53, 60, 04, 23},
	};
	sz := len t;
	rsz: int;

	for(i := sz - 2; i >= 0; i--) {
		rsz = len t[i];
		for(j := 0; j < rsz; j++) {
			(a, b) := (t[i+1][j], t[i+1][j+1]);
			if(a > b)
				t[i][j] += a;
			else
				t[i][j] += b;
		}
	}

	sys->print("%d\n", t[0][0]);
}
