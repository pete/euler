% Find the largest prime factor of 600851475143.

-module(p003).
-export([main/1, largest_factor/1]).

% Like in the Pez solution, we special-case 2 and just check which odd numbers
% divide N until N is 1.  When N is 1, we've hit the largest factor.

% I can't help but feel that I am somehow doing this algorithm wrong; it seems
% like I should not have written five different largest_factor(...)s, one with a
% case and one with a guard.  I have written something that is hard to read.
largest_factor(2) ->
	2;
largest_factor(N) ->
	case N rem 2 of
		0 -> largest_factor(N div 2);
		1 -> largest_factor(N, 3)
	end.
largest_factor(1, F) ->
	F;
largest_factor(N, F) when N rem F =:= 0 ->
	largest_factor(N div F, F);
largest_factor(N, F) ->
	largest_factor(N, F + 2).

main(_) ->
	io:write(largest_factor(600851475143)),
	io:fwrite("\n"),
	init:stop().
