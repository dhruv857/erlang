-module(simple).
-export([server/1, client/1, start/1]).

server (State) ->
  receive
    {request, Return_PID} ->

      io:format ("SERVER ~w: Client request received from ~w~n", [self(), Return_PID]),
      NewState = State + 1,
      Return_PID ! {hit_count, NewState},
      server (NewState);
    {server_owner, Owner_PID} ->

      io:format("SERVER ~w: Owner query received from ~w ~n",[self(), Owner_PID]),
      Owner_PID ! {hit_count, State},
      server (State);
    {reset,Return_PID} ->

      io:format("SERVER ~w: Owner reset message received ~n", [self()]),
      Return_PID ! {reset1Done},
      server(0)
  end.

client (Server_Address) ->
  Server_Address ! {request, self()},
  receive
    {hit_count, Number} ->
      io:format ("CLIENT ~w: Hit count was ~w~n", [self(), Number])
  end.

owner (Server_PID) ->
  Server_PID ! {server_owner, self()},

  receive
    %% check server State number
    {hit_count, Number} ->
      if
        Number == 6 -> % if owner find server state reaches 6, send a reset message as well
          io:format ("OWNER ~w: Hit count is ~w send reset message....~n", [self(), Number]),
          Server_PID ! {reset,self()},

          receive
            {reset1Done}  ->
            io:format("Owner : reset done~n"),
            owner(Server_PID)
        end;
        true ->
          io:format ("OWNER ~w: Hit count is ~w~n", [self(), Number])

      end
  end.

spawn_n(N, Server_PID) ->
  if
    N>0 ->

      spawn (simple, client, [Server_PID]),

      owner (Server_PID),
      spawn_n(N-1, Server_PID),
      timer:sleep(random:uniform(10000));

    N == 0 ->
      io:format("Last client spawned. ~n"),
      spawn_n(7, Server_PID)

  end.



start(Clients_Number) ->
  Server_PID = spawn (simple, server, [0]),

  timer:kill_after(1,Server_PID),
  owner(Server_PID),

  spawn_n(Clients_Number, Server_PID).
