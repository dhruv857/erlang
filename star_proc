-module (star_proc).
-export ([start/2, worker_loop/0, do_msg_exchange/1]).

start (N, M)->
    Pids = for (1, N, fun (_)-> spawn (star_proc, worker_loop, []) end),
    for (1, M, fun (_)-> lists:foreach (fun (Pid)-> do_msg_exchange (Pid) end, Pids) end),
    lists:foreach (fun (Pid)-> Pid! stop end, Pids).

do_msg_exchange (Pid)->
    io:format ("take ~w~n", [Pid]),
    Pid! {self (), take},
    receive
        takeback-> Pid
    end.

worker_loop ()->
    receive
        {From, take}->
            io:format ("took~n"),
            From! takeback,
            worker_loop ();
        stop->
            io:format ("deadman~n")
    end.

for (N, N, F) when N> 0->
    [F (N)];
for (B, E, F) when B> 0, E> 0->
    [F (B) |for (B+1, E, F)]. 
