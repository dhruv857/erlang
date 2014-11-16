-module (binary_search).
-export ([search/2]).

search(Set, Value) ->
    search(lists:sort(Set), Value, 1, length(Set)).

search(Set, Value, Low, High) ->
  if
    (High < Low) ->
      {notfound, Value};
    (true) ->
      Mid    = (Low + High) div 2,
      MidVal = lists:nth(Mid, Set),
      if
        (MidVal > Value) ->
          search(Set, Value, Low, Mid - 1);
        (MidVal < Value) ->
          search(Set, Value, Mid + 1, High);
        (true) ->
          {{value, Value}, {position, Mid}}
      end
  end.