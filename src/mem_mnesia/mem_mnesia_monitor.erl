-module(mem_mnesia_monitor).

-behaviour(gen_server).
-record(nodes_record, {node_prefix}).

-export([start_link/1]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2, terminate/2, code_change/3]).

start_link({BehaviorModule}) ->
	gen_server:start_link(?MODULE, [{BehaviorModule}], []).

init([{BehaviorModule}]) ->
	process_flag(trap_exit, true),

	mem_mnesia:init(),

	NodePrefix = apply(BehaviorModule,get_node_prefix,[]),
	NodesRecord = #nodes_record{node_prefix = NodePrefix},

	net_kernel:monitor_nodes(true),
	{ok, NodesRecord}.

handle_call(Msg, _From, State) ->
	{reply, {ok, Msg}, State}.

handle_cast(stop, State) ->
	{stop, normal, State};

handle_cast(_Request, State) ->
	{noreply, normal, State}.

handle_info({nodeup, UpNode}, #nodes_record{node_prefix = NodePrefix} = StateData) ->
	AllNodes = [node()] ++ nodes(),
	NewNodes = node_name_helper:get_nodes_with_prefix(AllNodes, NodePrefix),
	mem_mnesia:sync_up_node_db(NewNodes, UpNode),
	{noreply, StateData};

handle_info({nodedown, DownNode}, #nodes_record{node_prefix = NodePrefix} = StateData) ->
	AllNodes = [node()] ++ nodes(),
	NewNodes = node_name_helper:get_nodes_with_prefix(AllNodes, NodePrefix),
	mem_mnesia:sync_down_node_db(NewNodes, DownNode),
	{noreply, StateData};

handle_info(_Info, StateData) ->
	{noreply, StateData}.

terminate(_Reason, _StateData) ->
	net_kernel:monitor_nodes(false),
	ok.

code_change(_OldVsn, State, _Extra) ->
	{ok, State}.