:- use_module('../util/parser').

:- use_module(library(dcg/basics)).

:- initialization(main).

nums([N | Ns]) --> number(N), eol, nums(Ns).
nums([N]) --> number(N), eol.

process([_], []) :- !.
process([V1, V2 | Rest], [increased | Result]) :- V1 < V2, !, process([V2 | Rest], Result).
process([V1, V2 | Rest], [decreased | Result]) :- V1 > V2, !, process([V2 | Rest], Result).
process([_ | Rest], [equal | Result]) :- !, process(Rest, Result).

main :- 
    parse('input/day01_1.txt', nums, Numbers),
    process(Numbers, Result),
    include(=(increased), Result, Filtered),
    length(Filtered, Count),
    write(Count), nl,
    halt.