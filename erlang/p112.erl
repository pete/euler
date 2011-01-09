% Find the least number for which the proportion of bouncy numbers is exactly
% 99%.

% Runs in ~2s compiled, ~2m from escript.  Yikes.  I thought escript compiled
% code before running it.

-module(p112).
-compile(export_all).

ntol(N) -> ntol([], N).
ntol(L, 0) -> L;
ntol(L, N) -> ntol([N rem 10 | L], N div 10).

bouncy_p(N) when N < 100 -> false;
bouncy_p(N) ->
	L = ntol(N),
	Asc = lists:sort(L),
	(L =/= Asc) and (L =/= lists:reverse(Asc)).

find99() -> find99(0, 1, 2).
find99(Bouncy, NonBouncy, N) when Bouncy =:= (NonBouncy * 99) -> N - 1;
find99(Bouncy, NonBouncy, N) ->
	NB = bouncy_p(N),
	if
		NB ->
			find99(Bouncy + 1, NonBouncy, N + 1);
		not NB ->
			find99(Bouncy, NonBouncy + 1, N + 1)
	end.

main(_) ->
	io:format("~p\n", [find99()]).
