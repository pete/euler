% How many different ways can £2 be made using any number of coins?
-module(p031).
-export([main/1]).

p([], _) -> 1;
p(_, N) when N < 0 -> 0;
p([H|T], N) -> p(T, N) + p([H|T], N - H).

main(_) ->
	io:write(p([200, 100, 50, 20, 10, 5, 2], 200)),
	io:fwrite("\n").
