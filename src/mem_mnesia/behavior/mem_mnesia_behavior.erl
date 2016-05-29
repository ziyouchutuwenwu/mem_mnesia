-module(mem_mnesia_behavior).

-callback get_node_prefix()->
	NodePrefix :: string().