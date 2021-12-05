:- use_module('../util/parser').

:- use_module(library(dcg/basics)).

:- initialization(main).

patterns([]) --> string([]), eol.
patterns([Pattern | Patterns]) --> string(Pattern), eol, patterns(Patterns).

process([], [], []).
process([48 | Ps], [V | Vs], [NV | NVs]) :- NV is V - 1, process(Ps, Vs, NVs).
process([49 | Ps], [V | Vs], [NV | NVs]) :- NV is V + 1, process(Ps, Vs, NVs).

number_bit_string(S, N) :- reverse(S, RS), number_bit_string_(RS, N).

number_bit_string_([], 0).
number_bit_string_([0|Rest], N) :- number_bit_string_(Rest, ON), N is ON<<1.
number_bit_string_([1|Rest], N) :- number_bit_string_(Rest, ON), N is ON<<1 \/ 1.

main :- 
    parse('input/day03_1.txt', patterns, Patterns),

    nth0(0, Patterns, Pattern), length(Pattern, PatternLength),

    length(X, PatternLength), maplist(=(0), X),

    foldl(process, Patterns, X, Result),
    maplist([X1, X2]>>(X1 > 0 -> X2 = 1 ; X2 = 0), Result, BitString),
    maplist([X1, X2]>>(X1 > 0 -> X2 = 0 ; X2 = 1), Result, NegativeBitString),
    
    number_bit_string(BitString, N1),
    number_bit_string(NegativeBitString, N2),

    N3 is N1 * N2,

    write(N3), nl,

    halt.