% Find the sum of all the even-valued terms in the Fibonacci sequence which do
% not exceed four million.

-module(p002).
-export([seftil/1, main/1]).

ef(0) -> 2;
ef(1) -> 8;
ef(N) -> 4 * ef(N - 1) + ef(N - 2).

seftil(N, I, Acc) ->
	Ef = ef(I),
	case Ef > N of
		true -> Acc;
		false -> seftil(N, I + 1, Ef + Acc)
	end.
seftil(N) ->
	seftil(N, 0, 0).

main(_) ->
	io:write(seftil(4000000)),
	io:fwrite("\n"),
	init:stop().
