-module(insertion_sort).
-export([insertion_sort/1]).

insertion_sort([]) -> [];
insertion_sort([X | []]) -> [X];
 
insertion_sort(ToSort) -> insertion_sort(ToSort, []).
 
insertion_sort([], Sorted) -> Sorted;
 
insertion_sort(Unsorted, Sorted) -> Max = lists:max(Unsorted),
                                    insertion_sort(lists:delete(Max, Unsorted),                                              [Max] ++ Sorted).