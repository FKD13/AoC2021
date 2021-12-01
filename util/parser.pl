:- module('parser', [parse/3]).

get_codes(File, Codes) :-
    setup_call_cleanup(
        open(File, read, Fd, []), 
        read_string(Fd, _Length, String), 
        string_codes(String, Codes)
    ).

:- meta_predicate parse(+, 3, -).

parse(File, Parser, Return) :-
    get_codes(File, Codes),
    call(Parser,Return, Codes, []).