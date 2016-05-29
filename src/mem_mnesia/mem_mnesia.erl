-module(mem_mnesia).

-export([init/0,sync_up_node_db/2,sync_down_node_db/2]).

init()->
	mnesia:start().

sync_up_node_db(NodeList, UpNode)->
	case mnesia:change_config(extra_db_nodes, NodeList ) of
		{ok, _} ->
			add_db_to_cluster(UpNode);
		{error, Reason} ->
			io:format("sync_upnode_db error, reason=~p", [Reason])
	end.

sync_down_node_db(NodeList, DownNode)->
	case mnesia:change_config(extra_db_nodes, NodeList ) of
		{ok, _} ->
			remove_db_from_cluster(DownNode);
		{error, Reason} ->
			io:format("sync_upnode_db error, reason=~p", [Reason])
	end.

%%private methord
add_db_to_cluster(Node)->
	Tables = mnesia:system_info(tables),
	lists:foreach(
		fun(Table) ->
			mnesia:add_table_copy(Table, Node, ram_copies)
		end,
		Tables
	).

remove_db_from_cluster(Node)->
	Tables = mnesia:system_info(tables),
	lists:foreach(
		fun(Table) ->
			mnesia:del_table_copy(Table, Node)
		end,
		Tables
	).