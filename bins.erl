-module(bins).
-export([binary/2]).

binary(List, Value) ->
    binarys(List, Value, 1, length(List)).


binarys(List, Value, Low, High) ->

      if
        length(List) < 10 ->
          io:format("length of the list is less than 10. ");
      true ->
    if Low > High ->
        io:format("Number ~p not found in the list~n", [Value]);

       true ->
        Mid = (Low + High) div 2,
        MidNo = lists:nth(Mid, List),
        if MidNo > Value ->
            binarys(List, Value, Low, Mid-1);
           MidNo < Value ->
            binarys(List, Value, Mid+1, High);
           true ->
            io:format("Number ~p found at index ~p in the list~n", [Value, Mid])

        end
        end
    end.
