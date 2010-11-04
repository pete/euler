% Find the sum of all the even-valued terms in the Fibonacci sequence which do
% not exceed four million.

% I do not know how to properly express myself in this language.  Expect
% horrors.

% Also, I'd like to thank the Erlang designer(s) for using a terrible comment
% character.

-module(p002).
-export([seftil/1, main/1]).

sef(0) -> 0;
sef(N) -> ef(N) + sef(N - 1).

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

main(Argv) ->
	io:write(seftil(4000000)),
	io:fwrite("\n").
