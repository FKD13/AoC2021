:- use_module('../util/parser').

:- initialization(main).

digit(N) --> [N], {member(N, [48, 49, 50, 51, 52, 53, 54, 55, 56, 57])}.
digits([N | Ns]) --> digit(N), digits(Ns).
digits([N]) --> digit(N).

num(N) --> digits(Ns), {number_codes(N, Ns)}.

nums([N | Ns]) --> num(N), "\n", nums(Ns).
nums([N]) --> num(N).

calculate_windows(V1, V2, V3, V4, W1, W2) :- 
    W1 is V1 + V2 + V3,
    W2 is V2 + V3 + V4.

process([_], []) :- !.
process([V1, V2, V3, V4 | Rest], [increased | Result]) :- calculate_windows(V1, V2, V3, V4, W1, W2), W1 < W2, !, process([V2, V3, V4 | Rest], Result).
process([V1, V2, V3, V4 | Rest], [decreased | Result]) :- calculate_windows(V1, V2, V3, V4, W1, W2), W1 > W2, !, process([V2, V3, V4 | Rest], Result).
process([_ | Rest], [equal | Result]) :- !, process(Rest, Result).

main :- 
    parse('input/day01_1.txt', nums, Numbers),
    process(Numbers, Result),
    foldl([V1, V2, Res]>>(V1 = increased -> Res is V2 + 1; Res = V2), Result, 0, Count),
    write(Count), nl,
    halt.