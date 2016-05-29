-module(mem_mnesia_sup).

-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(BehaviorModule) ->
	supervisor:start_link(?MODULE, {BehaviorModule}).

init({BehaviorModule}) ->
	RestartStrategy = one_for_one,
	MaxRestarts = 1000,
	MaxSecondsBetweenRestarts = 3600,

	SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

	Restart = permanent,
	Shutdown = 2000,
	Type = worker,

	Child = {
		mem_mnesia_monitor,
		{mem_mnesia_monitor, start_link, [{BehaviorModule}]},
		Restart, Shutdown, Type,
		[mem_mnesia_monitor]
	},

	{ok, {SupFlags, [Child]}}.