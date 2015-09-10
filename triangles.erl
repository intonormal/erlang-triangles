-module(triangles).
-compile(export_all).


test1() ->
	P1 = $a,
	P2 = $b,
	Line = [$a, $b],
	true = sub([P1, P2], Line),
	ok.

sub([], _) -> true;
sub([H|T], Line) ->
	lists:member(H, Line) andalso sub(T, Line).

test2() ->
	P1 = $a,
	P2 = $b,
	P3 = $c,
	P4 = $d,
	Line1 = [$a, $c, $b],
	Line2 = [$c, $d],
	true = sub([P1, P2], Line1),
	false = sub([P1, P2], Line2),
	true = sub([P2, P3], Line1),
	false = sub([P2, P3], Line2),
	false = sub([P2, P4], Line1),
	false = sub([P2, P4], Line2),
	false = sub([P3, P4], Line1),
	true = sub([P3, P4], Line2),
	ok.
%%%%%%%%%%%%%test3() refactor test2()%%%%
	lines() ->
		Line1 = [$a, $c, $b],
		Line2 = [$c, $d],
		[Line1, Line2].

	belong(_, []) -> false;
	belong(S1, [H|T]) ->
		sub(S1, H) orelse belong(S1, T).

	connected(P1, P2, Lines) ->
		belong([P1, P2], Lines).
	
	test3() ->
		P1 = $a,
		P2 = $b,
		P3 = $c,
		P4 = $d,
		Line1 = [$a, $c, $b],
		Line2 = [$c, $d],
		Lines = [Line1, Line2], 
		true = connected(P1, P2, Lines),
		true = connected(P2, P3, Lines),
		false = connected(P2, P4, Lines),
		true = connected(P3, P4, Lines),
		ok.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	test4() ->
		P1 = $a,
		P2 = $b,
		P3 = $c,
		P4 = $d,
		true = on_a_line(P1, P2, P3,  lines()),
		false = on_a_line(P1, P2, P4, lines()),
		false = on_a_line(P1, P3, P4, lines()),
		false = on_a_line(P2, P3, P4, lines()),
		ok.

	on_a_line(P1, P2, P3, Lines) ->
		belong([P1, P2, P3], Lines).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	test5() ->
		P1 = $a,
		P2 = $b,
		P3 = $c,
		Lines = [[P1, P2], [P1, P3], [P2, P3]],
		true = triangles([P1, P2, P3], Lines),
		ok.
	
	triangles([P1, P2, P3], Lines) ->
		connected(P1, P2, Lines) andalso
		connected(P2, P3, Lines) andalso
		connected(P1, P3, Lines) andalso
		(not on_a_line(P1, P2, P3, Lines)).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	test6() ->
		P1 = $a,
		P2 = $b,
		P3 = $c,
		P4 = $d,
		Lines = [[P1, P3], [P1, P4, P2], [P3, P4], [P2, P3]],
		true = triangles([P1, P2, P3], Lines),
		false = triangles([P1, P2, P4], Lines),
		true = triangles([P1, P3, P4], Lines),
		true = triangles([P2, P3, P4], Lines),
		ok.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	
	test7() ->
		L = [$a, $b, $c, $d],
		[[$a], [$c], [$b], [$d]] = comb(L, 1),
		[[$a, $b], [$a, $c], [$a, $d], [$b, $c], [$b, $d], [$c, $d]]=comb(L, 2),
		[[$a, $b, $c], [$a, $b, $d], [$a, $c, $d], [$b, $c, $d]]=comb(L, 3),
		[[$a, $b, $c, $d]]=comb(L, 4),
		ok.

	comb(L, 1) -> [[I] || I <- L];
	comb(L, N) when length(L) =:= N ->
		[L];
	comb([H|T], N) ->
		[[H|I]||I<-comb(T, N-1)] ++ comb(T, N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	test8() ->
		P1 = $a,
		P2 = $b,
		P3 = $c,
		P4 = $d,
		Points = [P1, P2, P3, P4],
		Lines = [[P1, P3], [P1, P4, P2], [P3, P4], [P2, P3]],
		count(comb(Points, 3), Lines, {0,[]}),
		ok.

	count([], _, {N, L}) -> {N, L};
	count([H|T], Lines, {N, L}) ->
		case triangles(H, Lines) of
			true -> count(T, Lines, {N+1, [H]++L});
			false -> count(T, Lines, {N, L})
		end.

	test9() ->
		Points = "abcd",
		Lines = ["abd", "ac", "bc", "cd"],
		count(comb(Points, 3), Lines, {0,[]}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
	test10() ->
		Points = "abcdefghijk",
		Lines = ["abc","adef", "aghi","ajk","bdgj","cfik","cehj"],
		count(comb(Points, 3), Lines, {0,[]}).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
test() ->
	test1(),
	test2(),
	test3(),
	test4(),
	test5(),
	test6(),
	test7(),
	test8(),
	test9(),
	test10().

