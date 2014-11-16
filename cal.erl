-module(cal).
-export([area/1]).
area({square, Side}) ->
Side * Side;
area({circle, Radius}) ->
3.14159 * Radius * Radius;
area({rectangle, X, Y}) ->
X * Y;
area({rtriangle, B, H}) ->
0.5 * B * H.