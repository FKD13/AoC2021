:- use_module('../util/parser').

:- use_module(library(dcg/basics)).

:- initialization(main).

instruction(h(X   )) --> "forward ", number(X).
instruction(v(X   )) --> "down "   , number(X).
instruction(v(XMin)) --> "up "     , number(X), {XMin is -X}.

instructions([Instruction | Instructions]) --> instruction(Instruction), eol, instructions(Instructions).
instructions([Instruction]) --> instruction(Instruction), eol.

move(h(Step), [X, Y, Aim], [XNew, YNew, Aim]) :- XNew is X + Step, YNew is Y + Aim * Step.
move(v(Step), [X, Y, Aim], [X, Y, ANew]) :- ANew is Aim + Step.

main :- 
    parse('input/day02_1.txt', instructions, Instructions),
    
    foldl(move, Instructions, [0, 0, 0], [X, Y, _]),
    Product is X * Y,
    write(Product), nl,

    halt.