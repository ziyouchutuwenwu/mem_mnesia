-module(mnesia_demo).

-record(person, {
    name,
    sex,
    age
}).

-export([init/0]).
-export([create_table/0, delete_table/1]).
-export([read/1, batch_read/0]).
-export([write/0, batch_write/0]).

init() ->
    application:start(mem_mnesia).

create_table() ->
    mnesia:create_table(person, [
        {ram_copies, [node()]},
        {attributes, record_info(fields, person)}
    ]).

delete_table(Id) ->
    Fun = fun() ->
        mnesia:delete({person, Id})
    end,
    mnesia:transaction(Fun).

read(Age) ->
    Fun = fun() ->
        Match = #person{age = Age, _ = '_'},
        mnesia:match_object(Match)
    end,
    mnesia:transaction(Fun).

write() ->
    F = fun() ->
        Rec = #person{name = ~"aaa", sex = man, age = 20},
        mnesia:write(Rec)
    end,
    mnesia:transaction(F).

batch_read() ->
    Fun = fun() ->
        mnesia:foldl(
            fun(Record, Acc) ->
                [Record | Acc]
            end,
            [],
            person
        )
    end,
    mnesia:transaction(Fun).

batch_write() ->
    LoopCount = lists:seq(1, 1000),
    lists:foreach(
        fun(Index) ->
            F = fun() ->
                Rec = #person{name = Index, sex = man, age = Index},
                mnesia:write(Rec)
            end,
            mnesia:transaction(F)
        end,
        LoopCount
    ).
