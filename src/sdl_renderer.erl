%% Copyright (c) 2014-2015, Loïc Hoguin <essen@ninenines.eu>
%%
%% Permission to use, copy, modify, and/or distribute this software for any
%% purpose with or without fee is hereby granted, provided that the above
%% copyright notice and this permission notice appear in all copies.
%%
%% THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
%% WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
%% MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
%% ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
%% WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
%% ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
%% OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

-module(sdl_renderer).

-export([clear/1]).
-export([copy/2]).
-export([copy/4]).
-export([copy/7]).
-export([count_drivers/0]).
-export([create/3]).
-export([draw_circle/2]).
-export([draw_circle/4]).
-export([draw_line/3]).
-export([draw_line/5]).
-export([draw_lines/2]).
-export([draw_point/2]).
-export([draw_point/3]).
-export([draw_points/2]).
-export([draw_rect/2]).
-export([draw_rect/5]).
-export([draw_rects/2]).
-export([fill_circle/2]).
-export([fill_circle/4]).
-export([fill_rect/2]).
-export([fill_rect/5]).
-export([fill_rects/2]).
-export([get_clip_rect/1]).
-export([get_draw_blend_mode/1]).
-export([get_draw_color/1]).
-export([get_logical_size/1]).
-export([get_output_size/1]).
-export([get_scale/1]).
-export([get_viewport/1]).
-export([is_target_supported/1]).
-export([present/1]).
-export([set_clip_rect/2]).
-export([set_clip_rect/5]).
-export([set_draw_blend_mode/2]).
-export([set_draw_color/5]).
-export([set_logical_size/3]).
-export([set_scale/3]).
-export([set_viewport/2]).
-export([set_viewport/5]).

-opaque renderer() :: <<>>.
-export_type([renderer/0]).

-type renderer_flag() :: software | accelerated | present_vsync | target_texture.
-export_type([renderer_flag/0]).

-type circle() :: #{x=>integer(), y=>integer(), r=>integer()}.
-type point() :: #{x=>integer(), y=>integer()}.
-type rect() :: #{x=>integer(), y=>integer(), w=>integer(), h=>integer()}.

-type blend_mode() :: none | blend | add | mod.
-export_type([blend_mode/0]).

-spec clear(renderer()) -> ok | sdl:error().
clear(Renderer) ->
	esdl2:render_clear(Renderer),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec copy(renderer(), sdl_texture:texture()) -> ok | sdl:error().
copy(Renderer, Texture) ->
	esdl2:render_copy(Renderer, Texture, undefined, undefined),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec copy(renderer(), sdl_texture:texture(), undefined | rect(), undefined | rect())
	-> ok | sdl:error().
copy(Renderer, Texture, SrcRect, DstRect) ->
	esdl2:render_copy(Renderer, Texture, SrcRect, DstRect),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec copy(renderer(), sdl_texture:texture(), undefined | rect(), undefined | rect(),
	float(), undefined | point(), none | horizontal | vertical)
	-> ok | sdl:error().
copy(Renderer, Texture, SrcRect, DstRect, Angle, CenterPoint, FlipFlags) ->
	esdl2:render_copy_ex(Renderer, Texture, SrcRect, DstRect, Angle, CenterPoint, FlipFlags),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec count_drivers() -> integer().
count_drivers() ->
	{ok, Count} = esdl2:get_num_render_drivers(),
	Count.

-spec create(sdl_window:window(), integer(), [renderer_flag()])
	-> {ok, renderer()} | sdl:error().
create(Window, Index, Flags) ->
	esdl2:create_renderer(Window, Index, Flags),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec draw_circle(renderer(), circle()) -> ok | sdl:error().
draw_circle(Renderer, #{x:=X, y:=Y, r:=Radius}) ->
	draw_circle(Renderer, X, Y, Radius).

-spec draw_circle(renderer(), integer(), integer(), integer()) -> ok | sdl:error().
draw_circle(Renderer, X, Y, Radius) ->
	Points = midpoint_circle(X, Radius, Y, 0, 0),
	draw_points(Renderer, Points).

-spec midpoint_circle(integer(), integer(), integer(), integer(), integer()) -> list().
midpoint_circle(X0, X, Y0, Y, Err) when X >= Y ->
	Points = [#{x => X0 + X, y => Y0 + Y}, #{x => X0 - X, y => Y0 + Y}, #{x => X0 + Y, y => Y0 + X},
		  #{x => X0 - Y, y => Y0 + X}, #{x => X0 - X, y => Y0 - Y}, #{x => X0 + X, y => Y0 - Y},
		  #{x => X0 - Y, y => Y0 - X}, #{x => X0 + Y, y => Y0 - X}],
	New_Y = Y + 1,
	Tmp_Err = Err + 1 + (2 * New_Y),
	Midpoint_Values = determine_midpoint_values(X, Tmp_Err),
	Points ++ midpoint_circle(X0, maps:get(x, Midpoint_Values), Y0, New_Y, maps:get(err, Midpoint_Values));

midpoint_circle(_, _, _, _, _) ->
	[].

-spec determine_midpoint_values(integer(), integer()) -> map().
determine_midpoint_values(X, Err) when 2 * (Err - X) + 1 > 0 ->
	New_X = X - 1,
	New_Err = Err + 1 - (2 * New_X),
	#{x => New_X, err => New_Err};

determine_midpoint_values(X, Err) ->
	#{x => X, err => Err}.

-spec draw_line(renderer(), point(), point()) -> ok | sdl:error().
draw_line(Renderer, #{x:=X1, y:=Y1}, #{x:=X2, y:=Y2}) ->
	draw_line(Renderer, X1, Y1, X2, Y2).

-spec draw_line(renderer(), integer(), integer(), integer(), integer()) -> ok | sdl:error().
draw_line(Renderer, X1, Y1, X2, Y2) ->
	esdl2:render_draw_line(Renderer, X1, Y1, X2, Y2),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec draw_lines(renderer(), [point()]) -> ok | sdl:error().
draw_lines(Renderer, Points) ->
	esdl2:render_draw_lines(Renderer, Points),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec draw_point(renderer(), point()) -> ok | sdl:error().
draw_point(Renderer, #{x:=X, y:=Y}) ->
	draw_point(Renderer, X, Y).

-spec draw_point(renderer(), integer(), integer()) -> ok | sdl:error().
draw_point(Renderer, X, Y) ->
	esdl2:render_draw_point(Renderer, X, Y),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec draw_points(renderer(), [point()]) -> ok | sdl:error().
draw_points(Renderer, Points) ->
	esdl2:render_draw_points(Renderer, Points),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec draw_rect(renderer(), rect()) -> ok | sdl:error().
draw_rect(Renderer, #{x:=X, y:=Y, w:=W, h:=H}) ->
	draw_rect(Renderer, X, Y, W, H).

-spec draw_rect(renderer(), integer(), integer(), integer(), integer()) -> ok | sdl:error().
draw_rect(Renderer, X, Y, W, H) ->
	esdl2:render_draw_rect(Renderer, X, Y, W, H),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec draw_rects(renderer(), [rect()]) -> ok | sdl:error().
draw_rects(Renderer, Rects) ->
	esdl2:render_draw_rects(Renderer, Rects),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec fill_circle(renderer(), circle()) -> ok | sdl:error().
fill_circle(Renderer, #{x:=X, y:=Y, r:=Radius}) ->
	fill_circle(Renderer, X, Y, Radius).

-spec fill_circle(renderer(), integer(), integer(), integer()) -> ok | sdl:error().
fill_circle(Renderer, X, Y, Radius) ->
	Points = midpoint_circle(X, Radius, Y, 0, 0),
	fill_circle_draw_lines(Renderer, Points).

-spec fill_circle_draw_lines(renderer(), [point()]) -> ok | sdl:error().
fill_circle_draw_lines(Renderer, [P1, P2 | T]) ->
	draw_line(Renderer, P1, P2),
	fill_circle_draw_lines(Renderer, T);

fill_circle_draw_lines(_, []) ->
	ok.

-spec fill_rect(renderer(), rect()) -> ok | sdl:error().
fill_rect(Renderer, #{x:=X, y:=Y, w:=W, h:=H}) ->
	fill_rect(Renderer, X, Y, W, H).

-spec fill_rect(renderer(), integer(), integer(), integer(), integer()) -> ok | sdl:error().
fill_rect(Renderer, X, Y, W, H) ->
	esdl2:render_fill_rect(Renderer, X, Y, W, H),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec fill_rects(renderer(), [rect()]) -> ok | sdl:error().
fill_rects(Renderer, Rects) ->
	esdl2:render_fill_rects(Renderer, Rects),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec get_clip_rect(renderer()) -> rect().
get_clip_rect(Renderer) ->
	esdl2:render_get_clip_rect(Renderer),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec get_draw_blend_mode(renderer()) -> blend_mode().
get_draw_blend_mode(Renderer) ->
	esdl2:get_render_draw_blend_mode(Renderer),
	receive {'_nif_thread_ret_', Ret} ->
		{ok, Mode} = Ret,
		Mode
	end.

-spec get_draw_color(renderer()) -> {byte(), byte(), byte(), byte()}.
get_draw_color(Renderer) ->
	esdl2:get_render_draw_color(Renderer),
	receive {'_nif_thread_ret_', Ret} ->
		{ok, Mode} = Ret,
		Mode
	end.

-spec get_logical_size(renderer()) -> {integer(), integer()}.
get_logical_size(Renderer) ->
	esdl2:render_get_logical_size(Renderer),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec get_output_size(renderer()) -> {integer(), integer()}.
get_output_size(Renderer) ->
	esdl2:get_render_output_size(Renderer),
	receive {'_nif_thread_ret_', Ret} ->
		{ok, Mode} = Ret,
		Mode
	end.

-spec get_scale(renderer()) -> {float(), float()}.
get_scale(Renderer) ->
	esdl2:render_get_scale(Renderer),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec get_viewport(renderer()) -> rect().
get_viewport(Renderer) ->
	esdl2:render_get_viewport(Renderer),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec is_target_supported(renderer()) -> boolean().
is_target_supported(Renderer) ->
	esdl2:render_target_supported(Renderer),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec present(renderer()) -> ok.
present(Renderer) ->
	esdl2:render_present(Renderer).

-spec set_clip_rect(renderer(), rect()) -> ok | sdl:error().
set_clip_rect(Renderer, #{x:=X, y:=Y, w:=W, h:=H}) ->
	set_clip_rect(Renderer, X, Y, W, H).

-spec set_clip_rect(renderer(), integer(), integer(), integer(), integer()) -> ok | sdl:error().
set_clip_rect(Renderer, X, Y, W, H) ->
	esdl2:render_set_clip_rect(Renderer, X, Y, W, H),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec set_draw_blend_mode(renderer(), blend_mode()) -> ok | sdl:error().
set_draw_blend_mode(Renderer, BlendMode) ->
	esdl2:set_render_draw_blend_mode(Renderer, BlendMode),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec set_draw_color(renderer(), byte(), byte(), byte(), byte()) -> ok | sdl:error().
set_draw_color(Renderer, R, G, B, A) ->
	esdl2:set_render_draw_color(Renderer, R, G, B, A),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec set_logical_size(renderer(), integer(), integer()) -> ok | sdl:error().
set_logical_size(Renderer, W, H) ->
	esdl2:render_set_logical_size(Renderer, W, H),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec set_scale(renderer(), float(), float()) -> ok | sdl:error().
set_scale(Renderer, ScaleX, ScaleY) ->
	esdl2:render_set_scale(Renderer, ScaleX, ScaleY),
	receive {'_nif_thread_ret_', Ret} -> Ret end.

-spec set_viewport(renderer(), rect()) -> ok | sdl:error().
set_viewport(Renderer, #{x:=X, y:=Y, w:=W, h:=H}) ->
	set_viewport(Renderer, X, Y, W, H).

-spec set_viewport(renderer(), integer(), integer(), integer(), integer()) -> ok | sdl:error().
set_viewport(Renderer, X, Y, W, H) ->
	esdl2:render_set_viewport(Renderer, X, Y, W, H),
	receive {'_nif_thread_ret_', Ret} -> Ret end.
