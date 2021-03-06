// Copyright (c) 2014-2015, Loïc Hoguin <essen@ninenines.eu>
//
// Permission to use, copy, modify, and/or distribute this software for any
// purpose with or without fee is hereby granted, provided that the above
// copyright notice and this permission notice appear in all copies.
//
// THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
// WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
// ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
// WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
// ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
// OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

#ifndef __ESDL2_H__
#define __ESDL2_H__

#include "SDL.h"

// List of atoms used by this NIF.

#define NIF_ATOMS(A) \
	A(accelerated) \
	A(add) \
	A(allow_high_dpi) \
	A(audio) \
	A(blend) \
	A(borderless) \
	A(button) \
	A(callback) \
	A(caps) \
	A(centered) \
	A(charged) \
	A(charging) \
	A(clicks) \
	A(close) \
	A(data) \
	A(enter) \
	A(error) \
	A(event) \
	A(events) \
	A(everything) \
	A(exposed) \
	A(false) \
	A(focus_gained) \
	A(focus_lost) \
	A(foreign) \
	A(fullscreen) \
	A(fullscreen_desktop) \
	A(game_controller) \
	A(h) \
	A(haptic) \
	A(hidden) \
	A(horizontal) \
	A(input_focus) \
	A(input_grabbed) \
	A(joystick) \
	A(key_down) \
	A(key_up) \
	A(leave) \
	A(left) \
	A(left_alt) \
	A(left_ctrl) \
	A(left_gui) \
	A(left_shift) \
	A(ok) \
	A(maximized) \
	A(middle) \
	A(minimized) \
	A(mod) \
	A(mode) \
	A(mouse_down) \
	A(mouse_focus) \
	A(mouse_motion) \
	A(mouse_up) \
	A(mouse_wheel) \
	A(moved) \
	A(no_battery) \
	A(none) \
	A(num) \
	A(on_battery) \
	A(opengl) \
	A(present_vsync) \
	A(quit) \
	A(repeat) \
	A(resizable) \
	A(resized) \
	A(restored) \
	A(right) \
	A(right_alt) \
	A(right_ctrl) \
	A(right_gui) \
	A(right_shift) \
	A(scancode) \
	A(shown) \
	A(size_changed) \
	A(software) \
	A(state) \
	A(sym) \
	A(target_texture) \
	A(touch) \
	A(true) \
	A(timer) \
	A(timestamp) \
	A(type) \
	A(undefined) \
	A(unknown) \
	A(vertical) \
	A(video) \
	A(w) \
	A(which) \
	A(window) \
	A(window_id) \
	A(windowed) \
	A(x) \
	A(x1) \
	A(x2) \
	A(xrel) \
	A(y) \
	A(yrel) \
	A(_nif_thread_ret_)

// List of resources used by this NIF.

#define NIF_RES_TYPE(r) SDL_ ## r
#define NIF_RESOURCES(R) \
	R(GLContext) \
	R(Renderer) \
	R(Surface) \
	R(Texture) \
	R(Window)

// List of functions defined in this NIF.

#define NIF_FUNCTION_NAME(f) esdl2_ ## f
#define NIF_FUNCTIONS(F) \
	/* internal */ \
	F(register_callback_process, 0) \
	/* sdl */ \
	F(init, 1) \
	F(init_subsystem, 1) \
	F(quit, 0) \
	F(quit_subsystem, 1) \
	F(set_main_ready, 0) \
	F(was_init, 1) \
	/* sdl_clipboard */ \
	F(get_clipboard_text, 0) \
	F(has_clipboard_text, 0) \
	F(set_clipboard_text, 1) \
	/* sdl_cpu_info */ \
	F(get_cpu_cache_line_size, 0) \
	F(get_cpu_count, 0) \
	F(get_system_ram, 0) \
	F(has_3dnow, 0) \
	F(has_avx, 0) \
	F(has_altivec, 0) \
	F(has_mmx, 0) \
	F(has_rdtsc, 0) \
	F(has_sse, 0) \
	F(has_sse2, 0) \
	F(has_sse3, 0) \
	F(has_sse41, 0) \
	F(has_sse42, 0) \
	/* sdl_events */ \
	F(poll_event, 0) \
	/* sdl_filesystem */ \
	F(get_base_path, 0) \
	F(get_pref_path, 2) \
	/* sdl_gl */ \
	F(gl_create_context, 1) \
	F(gl_swap_window, 1) \
	/* sdl_hints */ \
	F(add_hint_callback, 3) \
	/* sdl_keyboard */ \
	F(is_text_input_active, 0) \
	F(start_text_input, 0) \
	F(stop_text_input, 0) \
	/* sdl_power */ \
	F(get_power_info, 0) \
	/* sdl_renderer */ \
	F(create_renderer, 3) \
	F(get_num_render_drivers, 0) \
	F(get_render_draw_blend_mode, 1) \
	F(get_render_draw_color, 1) \
	F(get_render_output_size, 1) \
	F(render_clear, 1) \
	F(render_copy, 4) \
	F(render_copy_ex, 7) \
	F(render_draw_line, 5) \
	F(render_draw_lines, 2) \
	F(render_draw_point, 3) \
	F(render_draw_points, 2) \
	F(render_draw_rect, 5) \
	F(render_draw_rects, 2) \
	F(render_fill_rect, 5) \
	F(render_fill_rects, 2) \
	F(render_get_clip_rect, 1) \
	F(render_get_logical_size, 1) \
	F(render_get_scale, 1) \
	F(render_get_viewport, 1) \
	F(render_present, 1) \
	F(render_set_clip_rect, 5) \
	F(render_set_logical_size, 3) \
	F(render_set_scale, 3) \
	F(render_set_viewport, 5) \
	F(render_target_supported, 1) \
	F(set_render_draw_blend_mode, 2) \
	F(set_render_draw_color, 5) \
	/* sdl_surface */ \
	F(img_load, 1) \
	F(from_text, 3) \
	/* sdl_texture */ \
	F(create_texture_from_surface, 2) \
	F(get_texture_alpha_mod, 1) \
	F(get_texture_blend_mode, 1) \
	F(get_texture_color_mod, 1) \
	F(set_texture_alpha_mod, 2) \
	F(set_texture_blend_mode, 2) \
	F(set_texture_color_mod, 4) \
	/* sdl_version */ \
	F(get_version, 0) \
	F(get_revision, 0) \
	/* sdl_window */ \
	F(create_window, 6) \
	F(create_window_and_renderer, 3) \
	F(get_window_brightness, 1) \
	F(get_window_display_index, 1) \
	F(get_window_flags, 1) \
	F(get_window_grab, 1) \
	F(get_window_id, 1) \
	F(get_window_maximum_size, 1) \
	F(get_window_minimum_size, 1) \
	F(get_window_position, 1) \
	F(get_window_size, 1) \
	F(get_window_title, 1) \
	F(hide_window, 1) \
	F(maximize_window, 1) \
	F(minimize_window, 1) \
	F(raise_window, 1) \
	F(restore_window, 1) \
	F(set_window_bordered, 2) \
	F(set_window_brightness, 2) \
	F(set_window_fullscreen, 2) \
	F(set_window_grab, 2) \
	F(set_window_icon, 2) \
	F(set_window_maximum_size, 3) \
	F(set_window_minimum_size, 3) \
	F(set_window_position, 3) \
	F(set_window_size, 3) \
	F(set_window_title, 2) \
	F(show_window, 1)

// Generated declarations for the NIF.

#include "nif_helpers.h"

NIF_ATOMS(NIF_ATOM_H_DECL)
NIF_RESOURCES(NIF_RES_H_DECL)
NIF_FUNCTIONS(NIF_FUNCTION_H_DECL)

// --

ErlNifPid* get_callback_process();

#define sdl_error_tuple(env) \
	enif_make_tuple2(env, \
		atom_error, \
		enif_make_string(env, SDL_GetError(), ERL_NIF_LATIN1) \
	);

#endif
