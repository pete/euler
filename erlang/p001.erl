% Find the sum of all the multiples of 3 or 5 below 1000.

% You can do this by hand fairly easily.  I am new to Erlang, though, and it
% was bugging me that I had not checked in a solution to the first problem.

-module(p001).
-export([main/1]).

triangle(N) -> (N * (N + 1)) div 2.

sum(N, Limit) -> N * triangle((Limit - 1) div N).

main(_) ->
	io:write(sum(3, 1000) + sum(5, 1000) - sum(15, 1000)),
	io:fwrite("\n"),
	init:stop().
