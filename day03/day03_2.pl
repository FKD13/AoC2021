:- use_module('../util/parser').

:- use_module(library(dcg/basics)).

:- initialization(main).

patterns([]) --> string([]), eol.
patterns([Pattern | Patterns]) --> string(Pattern), eol, patterns(Patterns).

number_bit_string(S, N) :- reverse(S, RS), number_bit_string_(RS, N).

number_bit_string_([], 0).
number_bit_string_([0|Rest], N) :- number_bit_string_(Rest, ON), N is ON<<1.
number_bit_string_([1|Rest], N) :- number_bit_string_(Rest, ON), N is ON<<1 \/ 1.

rating(_     , [Pattern], _    , Pattern).
rating(Filter, Patterns , Depth, Rating ) :-
    maplist([X, Element]>>nth0(Depth, X, Element), Patterns, Heads),
    foldl(process, Heads, 0, Result),
    call(Filter, Result, Depth, Patterns, Filtered),
    NDepth is Depth + 1,
    rating(Filter, Filtered, NDepth, Rating).

process(48, X, XMin ) :- XMin  is X - 1.
process(49, X, XPlus) :- XPlus is X + 1.

filter_oxygen(Count, Depth, Patterns, Filtered) :- Count >= 0, include([X]>>(nth0(Depth, X, Element), Element = 49), Patterns, Filtered).
filter_oxygen(Count, Depth, Patterns, Filtered) :- Count < 0, include([X]>>(nth0(Depth, X, Element), Element = 48), Patterns, Filtered).

filter_co2(Count, Depth, Patterns, Filtered) :- Count >= 0, include([X]>>(nth0(Depth, X, Element), Element = 48), Patterns, Filtered).
filter_co2(Count, Depth, Patterns, Filtered) :- Count < 0, include([X]>>(nth0(Depth, X, Element), Element = 49), Patterns, Filtered).

main :- 
    parse('input/day03_1.txt', patterns, Patterns), !,

    rating(filter_oxygen, Patterns, 0, RatingOxygen),
    rating(filter_co2, Patterns, 0, RatingCO2),

    maplist([X1, X2]>>(X1 = 48 -> X2 = 0 ; X2 = 1), RatingOxygen, BX1),
    maplist([X1, X2]>>(X1 = 48 -> X2 = 0 ; X2 = 1), RatingCO2, BX2),

    number_bit_string(BX1, X1),
    number_bit_string(BX2, X2),

    X3 is X1 * X2,

    write(X3), nl,

    halt.