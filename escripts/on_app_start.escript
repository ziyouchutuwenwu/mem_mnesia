-module(on_app_start).

main(_Args) ->
  io:format("~n"),
  interprete_modules().

interprete_modules() ->
  int:ni(mem_mnesia_monitor),
  int:ni(mem_mnesia_behavior_impl),
  int:ni(my_mnesia_test),
  int:ni(mem_mnesia),
  int:ni(mem_mnesia_sup),
  int:ni(mem_mnesia_app),
  int:ni(mem_mnesia_behavior),
  int:ni(node_name_helper),

  io:format("输入 int:interpreted(). 或者 il(). 查看模块列表~n").