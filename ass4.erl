-module(stat).
-export([start/1, center/1, first/0, second/0,third/0,fourth/0]).

center(0) ->
first ! finished ,
second ! finished,
third!finished,
fourth!finished,
    io:format("~p P0 finished~n", [self()]);

center(N) ->
   first ! {center, self()},
   second ! {center,self()},
   third ! {center,self()},
   fourth ! {center,self()},
    receive
        {first,F_PID} ->
            io:format("~p P0 received ~p P1~n", [self(),F_PID]);
       {second,S_PID} ->
            io:format("~p P0 received ~p P2 ~n",[self(),S_PID]);
      {third,T_PID} ->
 	io:format("~p P0 received ~p P3 ~n",[self(),T_PID]);
     {fourth,FO_PID} ->
	io:format("~p P0 received ~p P4 ~n",[self(),FO_PID])
    end,
    center(N - 1).

first() ->
    receive
        finished ->
            io:format("~p P1 finished~n", [self()]);
        {center, Center_PID} ->
            io:format("~p (P1 received ~p P0~n ~p", [self(),Center_PID]),
            Center_PID ! {first,self()},
            first()
    end.

second() ->
    receive
        finished ->
            io:format("~p P2 finished~n", [self()]);
        {center, Center_PID} ->
            io:format("~p P2 received ~p P0~n", [self(),Center_PID]),
            Center_PID ! {second,self()},
            second()
    end.

third() ->
    receive
        finished ->
            io:format("~p P3 finished~n", [self()]);
        {center, Center_PID} ->
            io:format("~p P3 received ~p P0~n", [self(),Center_PID]),
            Center_PID ! {third,self()},
            third()
    end.

fourth() ->
    receive
        finished ->
            io:format("~p P4 finished~n", [self()]);
        {center, Center_PID} ->
            io:format("~p P4 received ~p P0~n", [self(),Center_PID]),
            Center_PID ! {fourth,self()},
            fourth()
    end.


start(A) ->

   register(first, spawn(ass4, first, [])),
   register(second, spawn(ass4, second, [])),
   register(third, spawn(ass4, third, [])),
   register(fourth, spawn(ass4, fourth, [])),
  CID = spawn(ass4, center, [A]),
  io:format("~p P0(center) started~n", [CID]).
