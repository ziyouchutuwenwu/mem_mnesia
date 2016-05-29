-module(mem_mnesia_behavior_impl).

-behavior(mem_mnesia_behavior).
-export([get_node_prefix/0]).

get_node_prefix() ->
	"".