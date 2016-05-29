-module(mem_mnesia_app).

-behaviour(application).

-export([start/2, stop/1]).


start(_StartType, _StartArgs) ->
	mnesia:start(),
    mem_mnesia_sup:start_link(mem_mnesia_behavior_impl).

stop(_State) ->
	mnesia:stop(),
    ok.