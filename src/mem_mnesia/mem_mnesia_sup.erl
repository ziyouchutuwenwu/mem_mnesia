-module(mem_mnesia_sup).

-behaviour(supervisor).

-export([start_link/1]).
-export([init/1]).

start_link(BehaviorModule) ->
	supervisor:start_link(?MODULE, {BehaviorModule}).

init({BehaviorModule}) ->
  MaxRestarts = 1000,
  MaxSecondsBetweenRestarts = 3600,

  SupervisorFlags = #{
    strategy => one_for_one,
    intensity => MaxRestarts,
    period => MaxSecondsBetweenRestarts
  },

  ChildSpec = #{
    id => mem_mnesia_monitor,
    start => {mem_mnesia_monitor, start_link, [{BehaviorModule}]},
    restart => permanent,
    shutdown => 2000,
    type => worker,
    modules => [mem_mnesia_monitor]
  },

  Children = [ChildSpec],
  {ok, {SupervisorFlags, Children}}.