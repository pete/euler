% Find the number of triangles for which the interior contains the origin.

-module(p102).
%-export([main/1]).
-compile(export_all).

fname() -> "../data/102.txt". % The erlang stuff runs from tmp/

collector(Pid) -> collector(Pid, 0).
collector(Pid, N) ->
	receive
		triangle -> collector(Pid, N + 1);
		finish -> Pid ! N;
		WTF -> io:format("WTF ~p\n", [WTF])
	end.

cross_product([X1, Y1], [X2, Y2]) ->
	X1 * Y2 - X2 * Y1.
dot_prod([X1, Y1], [X2, Y2]) ->
	X1 * X2 + Y1 * Y2.

vector_sub([X1, Y1], [X2, Y2]) ->
	[X1-X2, Y1-Y2].

% Algorithm stolen from interesting site
% http://www.blackpawn.com/texts/pointinpoly/default.html !

triangle_contains_origin([A, B, C]) ->
	V0 = vector_sub(C, A),
	V1 = vector_sub(B, A),
	V2 = vector_sub([0, 0], A),

	D00 = dot_prod(V0, V0),
	D01 = dot_prod(V0, V1),
	D02 = dot_prod(V0, V2),
	D11 = dot_prod(V1, V1),
	D12 = dot_prod(V1, V2),

	Inv = 1 / (D00 * D11 - D01 * D01),
	U = (D11 * D02 - D01 * D12) * Inv,
	V = (D00 * D12 - D01 * D02) * Inv,

	% io:format("~p (~p / ~p) => ~p\n", [[A,B,C], U, V, ((U > 0) and (V > 0)) and ((U + V) < 1)]),
	((U > 0) and (V > 0)) and ((U + V) < 1).

checker(Collector) ->
	receive {triangle, Points} ->
			Tco = triangle_contains_origin(Points),
			if Tco -> Collector ! triangle;
			   true -> true
			end,
			checker(Collector);
		finish -> Collector ! finish
	end.

parse(Line) -> parse(Line, []).

parse([], [Y3, X3, Y2, X2, Y1, X1]) ->
	% io:format("~p,~p,~p\n", [{X1, Y1}, {X2, Y2}, {X3, Y3}]),
	[[X1, Y1], [X2, Y2], [X3, Y3]];
	% There must be a way to turn a list into pairs.  Anyway, strictly
	% speaking, there's no reason to care if the pairs are (x,y) or (y,x),
	% as transposing them doesn't change whether the triangle contains
	% (0,0).
parse([], Bad) ->
	io:format("Bad line!  ~p\n", [Bad]), [[1,1], [2,2], [3,3]];
parse(Line, Ints) ->
	[Int|Rest] = parse_int(Line),
	parse(Rest, [Int|Ints]).

parse_int(S) -> parse_int(0, S).

parse_int(0, [$-|T]) ->
	[H|R] = parse_int(0, T),
	[-H|R];
parse_int(Acc, "\n") ->
	[Acc|[]];
parse_int(Acc, [$,|T]) ->
	[Acc|T];
parse_int(Acc, [H|T]) ->
	parse_int(Acc * 10 + (H - $0), T).

parser(Checker) ->
	receive {line, L} ->
			Checker ! {triangle, parse(L)},
			parser(Checker);
		finish ->
			Checker ! finish
	end.

read_loop(Parser, File) ->
	case io:get_line(File, '') of
		{error, Reason} -> io:format("Error reading! ~p\n", [Reason]);
		eof -> Parser ! finish;
		Line -> Parser ! {line, Line}, read_loop(Parser, File)
	end.

reader(Parser, Fname) ->
	{ok, File} = file:open(Fname, read),
	read_loop(Parser, File),
	file:close(File).

spawn_collector(Pid) ->
	spawn(fun() -> collector(Pid) end).

spawn_checker(Collector) ->
	spawn(fun() -> checker(Collector) end).

spawn_parser(Checker) ->
	spawn(fun() -> parser(Checker) end).

spawn_reader(Parser) ->
	spawn(fun() -> reader(Parser, fname()) end).

main(_) ->
	Collector = spawn_collector(self()),
	Checker = spawn_checker(Collector),
	Parser = spawn_parser(Checker),
	spawn_reader(Parser),
	receive N -> io:format("~p\n", [N]) end,
	init:stop().
