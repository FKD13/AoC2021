:- use_module('../util/parser').

:- initialization(main).

digit(N) --> [N], {member(N, [48, 49, 50, 51, 52, 53, 54, 55, 56, 57])}.
digits([N | Ns]) --> digit(N), digits(Ns).
digits([N]) --> digit(N).

num(N) --> digits(Ns), {number_codes(N, Ns)}.

nums([N | Ns]) --> num(N), "\n", nums(Ns).
nums([N]) --> num(N).




process([_], []) :- !.
process([V1, V2 | Rest], [increased | Result]) :- V1 < V2, !, process([V2 | Rest], Result).
process([V1, V2 | Rest], [decreased | Result]) :- V1 > V2, !, process([V2 | Rest], Result).
process([_, V2 | Rest], [equal | Result]) :- !, process([V2 | Rest], Result).

main :- 
    parse('input/day01_1.txt', nums, Numbers),
    process(Numbers, Result),
    foldl([V1, V2, Res]>>(V1 = increased -> Res is V2 + 1; Res = V2), Result, 0, Count),
    write(Count), nl,
    halt.