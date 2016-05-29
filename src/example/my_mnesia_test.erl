-module(my_mnesia_test).

-record(
	person, {
		name,
		sex,
		age
}).

-compile(export_all).

init()->
	application:start(mem_mnesia).

create_table()->
	mnesia:create_table(person, [
		{ram_copies, [node()]},
		{attributes, record_info(fields, person)}
	]).

delete_table(Id) ->
	Fun = fun() ->
			mnesia:delete({person, Id})
	      end,
	mnesia:transaction(Fun).

write()->
	LoopCount = lists:seq(1, 1000),
	lists:foreach(
		fun(Index) ->
			F = fun() ->
					Rec = #person{name=Index, sex = man, age = Index},
					mnesia:write(Rec)
			    end,
			mnesia:transaction(F)
		end,
		LoopCount
	).