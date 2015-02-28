-module(simpl).

 -export([server/1,client/1,owner/1,spawn_n/2,start/1]).



 server(State) ->
 receive
 {request,Return_PID} ->
    io:format("SERVER ~w: Client request received from ~w~n",
          [self(), Return_PID]) ,
    NewState = State + 1,
    Return_PID ! {hit_count,NewState},
    server(NewState);
   {owner,Return_PID} ->
    io:format("SERVER ~w: Owner query received from ~w~n",
          [self(), Return_PID]) ,

    Return_PID ! {hit_count,State},
    server(State);

  {reset,Return_PID} ->

    io:format("Server ~w:Owner reset message received~n",[self()]) ,
    Return_PID ! {resetDone},
    server(0)
 end.

 client(Server_PID) ->

   Server_PID ! {request, self()},
   receive
     {hit_count,Number} ->
       io:format("CLIENT ~w: Hit count was ~w~n",[self(), Number])
   end.


 owner(Server_PID) ->

 %% Use a random sleep in ms to simulate the owner traffic pattern.
   timer:sleep(random:uniform(100)),

   Server_PID ! {owner,self()},
  receive
     {hit_count,Number} ->
         io:format("Owner ~w: Hit count is ~w~n",[self(), Number]),


    if
      Number<5 ->
        owner(Server_PID)	;

      Number >=5 ->
        timer:sleep(random:uniform(100)),
             Server_PID !  {reset,self()},

        receive
            {resetDone}  ->
            io:format("Owner : reset done~n"),
            owner(Server_PID)
        end


    end

   end.


spawn_n(N,Server_PID) ->

  if
    N>0 ->
      spawn(simple,client,[Server_PID]),

      %% Use a random sleep in miliseconds to simulate the
      %% client traffic pattern.
      timer:sleep(random:uniform(100)),

       spawn_n(N-1,Server_PID);
    N == 0 ->
        io:format("Last client spawned.~n")
 end.


 start(N) ->
 Server_PID = spawn(simpl,server,[0]),
 spawn(simpl,owner,[Server_PID]),
 spawn(simpl,spawn_n,[N,Server_PID]).
