/*
 *  libcaca     Colour ASCII-Art library
 *  Copyright © 2002—2018 Sam Hocevar <sam@hocevar.net>
 *              All Rights Reserved
 *
 *  This library is free software. It comes without any warranty, to
 *  the extent permitted by applicable law. You can redistribute it
 *  and/or modify it under the terms of the Do What the Fuck You Want
 *  to Public License, Version 2, as published by Sam Hocevar. See
 *  http://www.wtfpl.net/ for more details.
 */

/** \file caca.h
 *  \author Sam Hocevar <sam@hocevar.net>
 *  \brief The \e libcaca public header.
 *
 *  This header contains the public types and functions that applications
 *  using \e libcaca may use.
 */

import core.stdc.stdarg;
import core.sys.posix.unistd;

extern (C):

/** libcaca API version */

/** \e libcaca canvas */
struct caca_canvas;
alias caca_canvas_t = caca_canvas;
/** dither structure */
struct caca_dither;
alias caca_dither_t = caca_dither;
/** character font structure */
struct caca_charfont;
alias caca_charfont_t = caca_charfont;
/** bitmap font structure */
struct caca_font;
alias caca_font_t = caca_font;
/** file handle structure */
struct caca_file;
alias caca_file_t = caca_file;
/** \e libcaca display context */
struct caca_display;
alias caca_display_t = caca_display;
/** \e libcaca event structure */
alias caca_event_t = caca_event;

/** \defgroup caca_attr libcaca attribute definitions
 *
 *  Colours and styles that can be used with caca_set_attr().
 *
 *  @{ */
/** \e libcaca colour keyword */
enum caca_color {
  CACA_BLACK = 0x00, /**< The colour index for black. */
  CACA_BLUE = 0x01, /**< The colour index for blue. */
  CACA_GREEN = 0x02, /**< The colour index for green. */
  CACA_CYAN = 0x03, /**< The colour index for cyan. */
  CACA_RED = 0x04, /**< The colour index for red. */
  CACA_MAGENTA = 0x05, /**< The colour index for magenta. */
  CACA_BROWN = 0x06, /**< The colour index for brown. */
  CACA_LIGHTGRAY = 0x07, /**< The colour index for light gray. */
  CACA_DARKGRAY = 0x08, /**< The colour index for dark gray. */
  CACA_LIGHTBLUE = 0x09, /**< The colour index for blue. */
  CACA_LIGHTGREEN = 0x0a, /**< The colour index for light green. */
  CACA_LIGHTCYAN = 0x0b, /**< The colour index for light cyan. */
  CACA_LIGHTRED = 0x0c, /**< The colour index for light red. */
  CACA_LIGHTMAGENTA = 0x0d, /**< The colour index for light magenta. */
  CACA_YELLOW = 0x0e, /**< The colour index for yellow. */
  CACA_WHITE = 0x0f, /**< The colour index for white. */
  CACA_DEFAULT = 0x10, /**< The output driver's default colour. */
  CACA_TRANSPARENT = 0x20 /**< The transparent colour. */
}

alias CACA_BLACK = caca_color.CACA_BLACK;
alias CACA_BLUE = caca_color.CACA_BLUE;
alias CACA_GREEN = caca_color.CACA_GREEN;
alias CACA_CYAN = caca_color.CACA_CYAN;
alias CACA_RED = caca_color.CACA_RED;
alias CACA_MAGENTA = caca_color.CACA_MAGENTA;
alias CACA_BROWN = caca_color.CACA_BROWN;
alias CACA_LIGHTGRAY = caca_color.CACA_LIGHTGRAY;
alias CACA_DARKGRAY = caca_color.CACA_DARKGRAY;
alias CACA_LIGHTBLUE = caca_color.CACA_LIGHTBLUE;
alias CACA_LIGHTGREEN = caca_color.CACA_LIGHTGREEN;
alias CACA_LIGHTCYAN = caca_color.CACA_LIGHTCYAN;
alias CACA_LIGHTRED = caca_color.CACA_LIGHTRED;
alias CACA_LIGHTMAGENTA = caca_color.CACA_LIGHTMAGENTA;
alias CACA_YELLOW = caca_color.CACA_YELLOW;
alias CACA_WHITE = caca_color.CACA_WHITE;
alias CACA_DEFAULT = caca_color.CACA_DEFAULT;
alias CACA_TRANSPARENT = caca_color.CACA_TRANSPARENT;

/** \e libcaca style keyword */
enum caca_style {
  CACA_BOLD = 0x01, /**< The style mask for bold. */
  CACA_ITALICS = 0x02, /**< The style mask for italics. */
  CACA_UNDERLINE = 0x04, /**< The style mask for underline. */
  CACA_BLINK = 0x08 /**< The style mask for blink. */
}

alias CACA_BOLD = caca_style.CACA_BOLD;
alias CACA_ITALICS = caca_style.CACA_ITALICS;
alias CACA_UNDERLINE = caca_style.CACA_UNDERLINE;
alias CACA_BLINK = caca_style.CACA_BLINK;

/*  @} */

/** \brief User event type enumeration.
 *
 *  This enum serves two purposes:
 *  - Build listening masks for caca_get_event().
 *  - Define the type of a \e caca_event_t.
 */
enum caca_event_type {
  CACA_EVENT_NONE = 0x0000, /**< No event. */

  CACA_EVENT_KEY_PRESS = 0x0001, /**< A key was pressed. */
  CACA_EVENT_KEY_RELEASE = 0x0002, /**< A key was released. */
  CACA_EVENT_MOUSE_PRESS = 0x0004, /**< A mouse button was pressed. */
  CACA_EVENT_MOUSE_RELEASE = 0x0008, /**< A mouse button was released. */
  CACA_EVENT_MOUSE_MOTION = 0x0010, /**< The mouse was moved. */
  CACA_EVENT_RESIZE = 0x0020, /**< The window was resized. */
  CACA_EVENT_QUIT = 0x0040, /**< The user requested to quit. */

  CACA_EVENT_ANY = 0xffff /**< Bitmask for any event. */
}

alias CACA_EVENT_NONE = caca_event_type.CACA_EVENT_NONE;
alias CACA_EVENT_KEY_PRESS = caca_event_type.CACA_EVENT_KEY_PRESS;
alias CACA_EVENT_KEY_RELEASE = caca_event_type.CACA_EVENT_KEY_RELEASE;
alias CACA_EVENT_MOUSE_PRESS = caca_event_type.CACA_EVENT_MOUSE_PRESS;
alias CACA_EVENT_MOUSE_RELEASE = caca_event_type.CACA_EVENT_MOUSE_RELEASE;
alias CACA_EVENT_MOUSE_MOTION = caca_event_type.CACA_EVENT_MOUSE_MOTION;
alias CACA_EVENT_RESIZE = caca_event_type.CACA_EVENT_RESIZE;
alias CACA_EVENT_QUIT = caca_event_type.CACA_EVENT_QUIT;
alias CACA_EVENT_ANY = caca_event_type.CACA_EVENT_ANY;

/** \brief Handling of user events.
 *
 *  This structure is filled by caca_get_event() when an event is received.
 *  It is an opaque structure that should only be accessed through
 *  caca_event_get_type() and similar functions. The struct members may no
 *  longer be directly accessible in future versions.
 */
struct caca_event {
  caca_event_type type; /**< The event type. */
  union data /**< The event information data */ {
    struct mouse {
      int x;
      int y;
      int button;
    }

    struct resize {
      int w;
      int h;
    }

    struct key {
      int ch;
      uint utf32;
      char[8] utf8;
    }
  }

  ubyte[16] padding;
}

/** \brief Option parsing.
 *
 * This structure contains commandline parsing information for systems
 * where getopt_long() is unavailable.
 */
struct caca_option {
  const(char)* name;
  int has_arg;
  int* flag;
  int val;
}

/** \brief Special key values.
 *
 *  Special key values returned by caca_get_event() for which there is no
 *  printable ASCII equivalent.
 */
enum caca_key {
  CACA_KEY_UNKNOWN = 0x00, /**< Unknown key. */

  /* The following keys have ASCII equivalents */
  CACA_KEY_CTRL_A = 0x01, /**< The Ctrl-A key. */
  CACA_KEY_CTRL_B = 0x02, /**< The Ctrl-B key. */
  CACA_KEY_CTRL_C = 0x03, /**< The Ctrl-C key. */
  CACA_KEY_CTRL_D = 0x04, /**< The Ctrl-D key. */
  CACA_KEY_CTRL_E = 0x05, /**< The Ctrl-E key. */
  CACA_KEY_CTRL_F = 0x06, /**< The Ctrl-F key. */
  CACA_KEY_CTRL_G = 0x07, /**< The Ctrl-G key. */
  CACA_KEY_BACKSPACE = 0x08, /**< The backspace key. */
  CACA_KEY_TAB = 0x09, /**< The tabulation key. */
  CACA_KEY_CTRL_J = 0x0a, /**< The Ctrl-J key. */
  CACA_KEY_CTRL_K = 0x0b, /**< The Ctrl-K key. */
  CACA_KEY_CTRL_L = 0x0c, /**< The Ctrl-L key. */
  CACA_KEY_RETURN = 0x0d, /**< The return key. */
  CACA_KEY_CTRL_N = 0x0e, /**< The Ctrl-N key. */
  CACA_KEY_CTRL_O = 0x0f, /**< The Ctrl-O key. */
  CACA_KEY_CTRL_P = 0x10, /**< The Ctrl-P key. */
  CACA_KEY_CTRL_Q = 0x11, /**< The Ctrl-Q key. */
  CACA_KEY_CTRL_R = 0x12, /**< The Ctrl-R key. */
  CACA_KEY_PAUSE = 0x13, /**< The pause key. */
  CACA_KEY_CTRL_T = 0x14, /**< The Ctrl-T key. */
  CACA_KEY_CTRL_U = 0x15, /**< The Ctrl-U key. */
  CACA_KEY_CTRL_V = 0x16, /**< The Ctrl-V key. */
  CACA_KEY_CTRL_W = 0x17, /**< The Ctrl-W key. */
  CACA_KEY_CTRL_X = 0x18, /**< The Ctrl-X key. */
  CACA_KEY_CTRL_Y = 0x19, /**< The Ctrl-Y key. */
  CACA_KEY_CTRL_Z = 0x1a, /**< The Ctrl-Z key. */
  CACA_KEY_ESCAPE = 0x1b, /**< The escape key. */
  CACA_KEY_DELETE = 0x7f, /**< The delete key. */

  /* The following keys do not have ASCII equivalents but have been
     * chosen to match the SDL equivalents */
  CACA_KEY_UP = 0x111, /**< The up arrow key. */
  CACA_KEY_DOWN = 0x112, /**< The down arrow key. */
  CACA_KEY_LEFT = 0x113, /**< The left arrow key. */
  CACA_KEY_RIGHT = 0x114, /**< The right arrow key. */

  CACA_KEY_INSERT = 0x115, /**< The insert key. */
  CACA_KEY_HOME = 0x116, /**< The home key. */
  CACA_KEY_END = 0x117, /**< The end key. */
  CACA_KEY_PAGEUP = 0x118, /**< The page up key. */
  CACA_KEY_PAGEDOWN = 0x119, /**< The page down key. */

  CACA_KEY_F1 = 0x11a, /**< The F1 key. */
  CACA_KEY_F2 = 0x11b, /**< The F2 key. */
  CACA_KEY_F3 = 0x11c, /**< The F3 key. */
  CACA_KEY_F4 = 0x11d, /**< The F4 key. */
  CACA_KEY_F5 = 0x11e, /**< The F5 key. */
  CACA_KEY_F6 = 0x11f, /**< The F6 key. */
  CACA_KEY_F7 = 0x120, /**< The F7 key. */
  CACA_KEY_F8 = 0x121, /**< The F8 key. */
  CACA_KEY_F9 = 0x122, /**< The F9 key. */
  CACA_KEY_F10 = 0x123, /**< The F10 key. */
  CACA_KEY_F11 = 0x124, /**< The F11 key. */
  CACA_KEY_F12 = 0x125, /**< The F12 key. */
  CACA_KEY_F13 = 0x126, /**< The F13 key. */
  CACA_KEY_F14 = 0x127, /**< The F14 key. */
  CACA_KEY_F15 = 0x128 /**< The F15 key. */
}

alias CACA_KEY_UNKNOWN = caca_key.CACA_KEY_UNKNOWN;
alias CACA_KEY_CTRL_A = caca_key.CACA_KEY_CTRL_A;
alias CACA_KEY_CTRL_B = caca_key.CACA_KEY_CTRL_B;
alias CACA_KEY_CTRL_C = caca_key.CACA_KEY_CTRL_C;
alias CACA_KEY_CTRL_D = caca_key.CACA_KEY_CTRL_D;
alias CACA_KEY_CTRL_E = caca_key.CACA_KEY_CTRL_E;
alias CACA_KEY_CTRL_F = caca_key.CACA_KEY_CTRL_F;
alias CACA_KEY_CTRL_G = caca_key.CACA_KEY_CTRL_G;
alias CACA_KEY_BACKSPACE = caca_key.CACA_KEY_BACKSPACE;
alias CACA_KEY_TAB = caca_key.CACA_KEY_TAB;
alias CACA_KEY_CTRL_J = caca_key.CACA_KEY_CTRL_J;
alias CACA_KEY_CTRL_K = caca_key.CACA_KEY_CTRL_K;
alias CACA_KEY_CTRL_L = caca_key.CACA_KEY_CTRL_L;
alias CACA_KEY_RETURN = caca_key.CACA_KEY_RETURN;
alias CACA_KEY_CTRL_N = caca_key.CACA_KEY_CTRL_N;
alias CACA_KEY_CTRL_O = caca_key.CACA_KEY_CTRL_O;
alias CACA_KEY_CTRL_P = caca_key.CACA_KEY_CTRL_P;
alias CACA_KEY_CTRL_Q = caca_key.CACA_KEY_CTRL_Q;
alias CACA_KEY_CTRL_R = caca_key.CACA_KEY_CTRL_R;
alias CACA_KEY_PAUSE = caca_key.CACA_KEY_PAUSE;
alias CACA_KEY_CTRL_T = caca_key.CACA_KEY_CTRL_T;
alias CACA_KEY_CTRL_U = caca_key.CACA_KEY_CTRL_U;
alias CACA_KEY_CTRL_V = caca_key.CACA_KEY_CTRL_V;
alias CACA_KEY_CTRL_W = caca_key.CACA_KEY_CTRL_W;
alias CACA_KEY_CTRL_X = caca_key.CACA_KEY_CTRL_X;
alias CACA_KEY_CTRL_Y = caca_key.CACA_KEY_CTRL_Y;
alias CACA_KEY_CTRL_Z = caca_key.CACA_KEY_CTRL_Z;
alias CACA_KEY_ESCAPE = caca_key.CACA_KEY_ESCAPE;
alias CACA_KEY_DELETE = caca_key.CACA_KEY_DELETE;
alias CACA_KEY_UP = caca_key.CACA_KEY_UP;
alias CACA_KEY_DOWN = caca_key.CACA_KEY_DOWN;
alias CACA_KEY_LEFT = caca_key.CACA_KEY_LEFT;
alias CACA_KEY_RIGHT = caca_key.CACA_KEY_RIGHT;
alias CACA_KEY_INSERT = caca_key.CACA_KEY_INSERT;
alias CACA_KEY_HOME = caca_key.CACA_KEY_HOME;
alias CACA_KEY_END = caca_key.CACA_KEY_END;
alias CACA_KEY_PAGEUP = caca_key.CACA_KEY_PAGEUP;
alias CACA_KEY_PAGEDOWN = caca_key.CACA_KEY_PAGEDOWN;
alias CACA_KEY_F1 = caca_key.CACA_KEY_F1;
alias CACA_KEY_F2 = caca_key.CACA_KEY_F2;
alias CACA_KEY_F3 = caca_key.CACA_KEY_F3;
alias CACA_KEY_F4 = caca_key.CACA_KEY_F4;
alias CACA_KEY_F5 = caca_key.CACA_KEY_F5;
alias CACA_KEY_F6 = caca_key.CACA_KEY_F6;
alias CACA_KEY_F7 = caca_key.CACA_KEY_F7;
alias CACA_KEY_F8 = caca_key.CACA_KEY_F8;
alias CACA_KEY_F9 = caca_key.CACA_KEY_F9;
alias CACA_KEY_F10 = caca_key.CACA_KEY_F10;
alias CACA_KEY_F11 = caca_key.CACA_KEY_F11;
alias CACA_KEY_F12 = caca_key.CACA_KEY_F12;
alias CACA_KEY_F13 = caca_key.CACA_KEY_F13;
alias CACA_KEY_F14 = caca_key.CACA_KEY_F14;
alias CACA_KEY_F15 = caca_key.CACA_KEY_F15;

/** \defgroup libcaca libcaca basic functions
 *
 *  These functions provide the basic \e libcaca routines for library
 *  initialisation, system information retrieval and configuration.
 *
 *  @{ */
caca_canvas_t* caca_create_canvas(int, int);
int caca_manage_canvas(caca_canvas_t*, int function(void*), void*);
int caca_unmanage_canvas(caca_canvas_t*, int function(void*), void*);
int caca_set_canvas_size(caca_canvas_t*, int, int);
int caca_get_canvas_width(const(caca_canvas_t)*);
int caca_get_canvas_height(const(caca_canvas_t)*);
const(uint)* caca_get_canvas_chars(const(caca_canvas_t)*);
const(uint)* caca_get_canvas_attrs(const(caca_canvas_t)*);
int caca_free_canvas(caca_canvas_t*);
int caca_rand(int, int);
const(char)* caca_get_version();
/*  @} */

/** \defgroup caca_canvas libcaca canvas drawing
 *
 *  These functions provide low-level character printing routines and
 *  higher level graphics functions.
 *
 *  @{ */
enum CACA_MAGIC_FULLWIDTH = 0x000ffffe; /**< Used to indicate that the previous character was a fullwidth glyph. */
int caca_gotoxy(caca_canvas_t*, int, int);
int caca_wherex(const(caca_canvas_t)*);
int caca_wherey(const(caca_canvas_t)*);
int caca_put_char(caca_canvas_t*, int, int, uint);
uint caca_get_char(const(caca_canvas_t)*, int, int);
int caca_put_str(caca_canvas_t*, int, int, const(char)*);
int caca_printf(caca_canvas_t*, int, int, const(char)*, ...);
int caca_vprintf(caca_canvas_t*, int, int, const(char)*, va_list);
int caca_clear_canvas(caca_canvas_t*);
int caca_set_canvas_handle(caca_canvas_t*, int, int);
int caca_get_canvas_handle_x(const(caca_canvas_t)*);
int caca_get_canvas_handle_y(const(caca_canvas_t)*);
int caca_blit(caca_canvas_t*, int, int, const(caca_canvas_t)*, const(caca_canvas_t)*);
int caca_set_canvas_boundaries(caca_canvas_t*, int, int, int, int);
/*  @} */

/** \defgroup caca_dirty libcaca dirty rectangle manipulation
 *
 *  These functions manipulate dirty rectangles for optimised blitting.
 *  @{ */
int caca_disable_dirty_rect(caca_canvas_t*);
int caca_enable_dirty_rect(caca_canvas_t*);
int caca_get_dirty_rect_count(caca_canvas_t*);
int caca_get_dirty_rect(caca_canvas_t*, int, int*, int*, int*, int*);
int caca_add_dirty_rect(caca_canvas_t*, int, int, int, int);
int caca_remove_dirty_rect(caca_canvas_t*, int, int, int, int);
int caca_clear_dirty_rect_list(caca_canvas_t*);
/*  @} */

/** \defgroup caca_transform libcaca canvas transformation
 *
 *  These functions perform horizontal and vertical canvas flipping.
 *
 *  @{ */
int caca_invert(caca_canvas_t*);
int caca_flip(caca_canvas_t*);
int caca_flop(caca_canvas_t*);
int caca_rotate_180(caca_canvas_t*);
int caca_rotate_left(caca_canvas_t*);
int caca_rotate_right(caca_canvas_t*);
int caca_stretch_left(caca_canvas_t*);
int caca_stretch_right(caca_canvas_t*);
/*  @} */

/** \defgroup caca_attributes libcaca attribute conversions
 *
 *  These functions perform conversions between attribute values.
 *
 *  @{ */
uint caca_get_attr(const(caca_canvas_t)*, int, int);
int caca_set_attr(caca_canvas_t*, uint);
int caca_unset_attr(caca_canvas_t*, uint);
int caca_toggle_attr(caca_canvas_t*, uint);
int caca_put_attr(caca_canvas_t*, int, int, uint);
int caca_set_color_ansi(caca_canvas_t*, ubyte, ubyte);
int caca_set_color_argb(caca_canvas_t*, ushort, ushort);
ubyte caca_attr_to_ansi(uint);
ubyte caca_attr_to_ansi_fg(uint);
ubyte caca_attr_to_ansi_bg(uint);
ushort caca_attr_to_rgb12_fg(uint);
ushort caca_attr_to_rgb12_bg(uint);
void caca_attr_to_argb64(uint, ref ubyte[8]);
/*  @} */

/** \defgroup caca_charset libcaca character set conversions
 *
 *  These functions perform conversions between usual character sets.
 *
 *  @{ */
uint caca_utf8_to_utf32(const(char)*, size_t*);
size_t caca_utf32_to_utf8(char*, uint);
ubyte caca_utf32_to_cp437(uint);
uint caca_cp437_to_utf32(ubyte);
char caca_utf32_to_ascii(uint);
int caca_utf32_is_fullwidth(uint);
/*  @} */

/** \defgroup caca_primitives libcaca primitives drawing
 *
 *  These functions provide routines for primitive drawing, such as lines,
 *  boxes, triangles and ellipses.
 *
 *  @{ */
int caca_draw_line(caca_canvas_t*, int, int, int, int, uint);
int caca_draw_polyline(caca_canvas_t*, const(int)* x, const(int)* y, int, uint);
int caca_draw_thin_line(caca_canvas_t*, int, int, int, int);
int caca_draw_thin_polyline(caca_canvas_t*, const(int)* x, const(int)* y, int);

int caca_draw_circle(caca_canvas_t*, int, int, int, uint);
int caca_draw_ellipse(caca_canvas_t*, int, int, int, int, uint);
int caca_draw_thin_ellipse(caca_canvas_t*, int, int, int, int);
int caca_fill_ellipse(caca_canvas_t*, int, int, int, int, uint);

int caca_draw_box(caca_canvas_t*, int, int, int, int, uint);
int caca_draw_thin_box(caca_canvas_t*, int, int, int, int);
int caca_draw_cp437_box(caca_canvas_t*, int, int, int, int);
int caca_fill_box(caca_canvas_t*, int, int, int, int, uint);

int caca_draw_triangle(caca_canvas_t*, int, int, int, int, int, int, uint);
int caca_draw_thin_triangle(caca_canvas_t*, int, int, int, int, int, int);
int caca_fill_triangle(caca_canvas_t*, int, int, int, int, int, int, uint);
int caca_fill_triangle_textured(caca_canvas_t* cv, ref int[6] coords,
    caca_canvas_t* tex, ref float[6] uv);
/*  @} */

/** \defgroup caca_frame libcaca canvas frame handling
 *
 *  These functions provide high level routines for canvas frame insertion,
 *  removal, copying etc.
 *
 *  @{ */
int caca_get_frame_count(const(caca_canvas_t)*);
int caca_set_frame(caca_canvas_t*, int);
const(char)* caca_get_frame_name(const(caca_canvas_t)*);
int caca_set_frame_name(caca_canvas_t*, const(char)*);
int caca_create_frame(caca_canvas_t*, int);
int caca_free_frame(caca_canvas_t*, int);
/*  @} */

/** \defgroup caca_dither libcaca bitmap dithering
 *
 *  These functions provide high level routines for dither allocation and
 *  rendering.
 *
 *  @{ */
caca_dither_t* caca_create_dither(int, int, int, int, uint, uint, uint, uint);
int caca_set_dither_palette(caca_dither_t*, uint* r, uint* g, uint* b, uint* a);
int caca_set_dither_brightness(caca_dither_t*, float);
float caca_get_dither_brightness(const(caca_dither_t)*);
int caca_set_dither_gamma(caca_dither_t*, float);
float caca_get_dither_gamma(const(caca_dither_t)*);
int caca_set_dither_contrast(caca_dither_t*, float);
float caca_get_dither_contrast(const(caca_dither_t)*);
int caca_set_dither_antialias(caca_dither_t*, const(char)*);
const(char*)* caca_get_dither_antialias_list(const(caca_dither_t)*);
const(char)* caca_get_dither_antialias(const(caca_dither_t)*);
int caca_set_dither_color(caca_dither_t*, const(char)*);
const(char*)* caca_get_dither_color_list(const(caca_dither_t)*);
const(char)* caca_get_dither_color(const(caca_dither_t)*);
int caca_set_dither_charset(caca_dither_t*, const(char)*);
const(char*)* caca_get_dither_charset_list(const(caca_dither_t)*);
const(char)* caca_get_dither_charset(const(caca_dither_t)*);
int caca_set_dither_algorithm(caca_dither_t*, const(char)*);
const(char*)* caca_get_dither_algorithm_list(const(caca_dither_t)*);
const(char)* caca_get_dither_algorithm(const(caca_dither_t)*);
int caca_dither_bitmap(caca_canvas_t*, int, int, int, int, const(caca_dither_t)*, const(void)*);
int caca_free_dither(caca_dither_t*);
/*  @} */

/** \defgroup caca_charfont libcaca character font handling
 *
 *  These functions provide character font handling routines.
 *
 *  @{ */
caca_charfont_t* caca_load_charfont(const(void)*, size_t);
int caca_free_charfont(caca_charfont_t*);
/*  @} */

/** \defgroup caca_font libcaca bitmap font handling
 *
 *  These functions provide bitmap font handling routines and high quality
 *  canvas to bitmap rendering.
 *
 *  @{ */
caca_font_t* caca_load_font(const(void)*, size_t);
const(char*)* caca_get_font_list();
int caca_get_font_width(const(caca_font_t)*);
int caca_get_font_height(const(caca_font_t)*);
const(uint)* caca_get_font_blocks(const(caca_font_t)*);
int caca_render_canvas(const(caca_canvas_t)*, const(caca_font_t)*, void*, int, int, int);
int caca_free_font(caca_font_t*);
/*  @} */

/** \defgroup caca_figfont libcaca FIGfont handling
 *
 *  These functions provide FIGlet and TOIlet font handling routines.
 *
 *  @{ */
int caca_canvas_set_figfont(caca_canvas_t*, const(char)*);
int caca_set_figfont_smush(caca_canvas_t*, const(char)*);
int caca_set_figfont_width(caca_canvas_t*, int);
int caca_put_figchar(caca_canvas_t*, uint);
int caca_flush_figlet(caca_canvas_t*);
/*  @} */

/** \defgroup caca_file libcaca file IO
 *
 *  These functions allow to read and write files in a platform-independent
 *  way.
 *  @{ */
caca_file_t* caca_file_open(const(char)*, const(char)*);
int caca_file_close(caca_file_t*);
ulong caca_file_tell(caca_file_t*);
size_t caca_file_read(caca_file_t*, void*, size_t);
size_t caca_file_write(caca_file_t*, const(void)*, size_t);
char* caca_file_gets(caca_file_t*, char*, int);
int caca_file_eof(caca_file_t*);
/*  @} */

/** \defgroup caca_importexport libcaca importers/exporters from/to various
 *  formats
 *
 *  These functions import various file formats into a new canvas, or export
 *  the current canvas to various text formats.
 *
 *  @{ */
ssize_t caca_import_canvas_from_memory(caca_canvas_t*, const(void)*, size_t, const(char)*);
ssize_t caca_import_canvas_from_file(caca_canvas_t*, const(char)*, const(char)*);
ssize_t caca_import_area_from_memory(caca_canvas_t*, int, int, const(void)*,
    size_t, const(char)*);
ssize_t caca_import_area_from_file(caca_canvas_t*, int, int, const(char)*, const(char)*);
const(char*)* caca_get_import_list();
void* caca_export_canvas_to_memory(const(caca_canvas_t)*, const(char)*, size_t*);
void* caca_export_area_to_memory(const(caca_canvas_t)*, int, int, int, int,
    const(char)*, size_t*);
const(char*)* caca_get_export_list();
/*  @} */

/** \defgroup caca_display libcaca display functions
 *
 *  These functions provide the basic \e libcaca routines for display
 *  initialisation, system information retrieval and configuration.
 *
 *  @{ */
caca_display_t* caca_create_display(caca_canvas_t*);
caca_display_t* caca_create_display_with_driver(caca_canvas_t*, const(char)*);
const(char*)* caca_get_display_driver_list();
const(char)* caca_get_display_driver(caca_display_t*);
int caca_set_display_driver(caca_display_t*, const(char)*);
int caca_free_display(caca_display_t*);
caca_canvas_t* caca_get_canvas(caca_display_t*);
int caca_refresh_display(caca_display_t*);
int caca_set_display_time(caca_display_t*, int);
int caca_get_display_time(const(caca_display_t)*);
int caca_get_display_width(const(caca_display_t)*);
int caca_get_display_height(const(caca_display_t)*);
int caca_set_display_title(caca_display_t*, const(char)*);
int caca_set_mouse(caca_display_t*, int);
int caca_set_cursor(caca_display_t*, int);
/*  @} */

/** \defgroup caca_event libcaca event handling
 *
 *  These functions handle user events such as keyboard input and mouse
 *  clicks.
 *
 *  @{ */
int caca_get_event(caca_display_t*, int, caca_event_t*, int);
int caca_get_mouse_x(const(caca_display_t)*);
int caca_get_mouse_y(const(caca_display_t)*);
caca_event_type caca_get_event_type(const(caca_event_t)*);
int caca_get_event_key_ch(const(caca_event_t)*);
uint caca_get_event_key_utf32(const(caca_event_t)*);
int caca_get_event_key_utf8(const(caca_event_t)*, char*);
int caca_get_event_mouse_button(const(caca_event_t)*);
int caca_get_event_mouse_x(const(caca_event_t)*);
int caca_get_event_mouse_y(const(caca_event_t)*);
int caca_get_event_resize_width(const(caca_event_t)*);
int caca_get_event_resize_height(const(caca_event_t)*);
/*  @} */

/** \defgroup caca_process libcaca process management
 *
 *  These functions help with various process handling tasks such as
 *  option parsing, DLL injection.
 *
 *  @{ */
extern __gshared int caca_optind;
extern __gshared char* caca_optarg;
int caca_getopt(int, const(char*)*, const(char)*, const(caca_option)*, int*);
/*  @} */

/** \brief DOS colours
 *
 *  This enum lists the colour values for the DOS conio.h compatibility
 *  layer.
 */
enum CACA_CONIO_COLORS {
  CACA_CONIO_BLINK = 128,
  CACA_CONIO_BLACK = 0,
  CACA_CONIO_BLUE = 1,
  CACA_CONIO_GREEN = 2,
  CACA_CONIO_CYAN = 3,
  CACA_CONIO_RED = 4,
  CACA_CONIO_MAGENTA = 5,
  CACA_CONIO_BROWN = 6,
  CACA_CONIO_LIGHTGRAY = 7,
  CACA_CONIO_DARKGRAY = 8,
  CACA_CONIO_LIGHTBLUE = 9,
  CACA_CONIO_LIGHTGREEN = 10,
  CACA_CONIO_LIGHTCYAN = 11,
  CACA_CONIO_LIGHTRED = 12,
  CACA_CONIO_LIGHTMAGENTA = 13,
  CACA_CONIO_YELLOW = 14,
  CACA_CONIO_WHITE = 15
}

alias CACA_CONIO_BLINK = CACA_CONIO_COLORS.CACA_CONIO_BLINK;
alias CACA_CONIO_BLACK = CACA_CONIO_COLORS.CACA_CONIO_BLACK;
alias CACA_CONIO_BLUE = CACA_CONIO_COLORS.CACA_CONIO_BLUE;
alias CACA_CONIO_GREEN = CACA_CONIO_COLORS.CACA_CONIO_GREEN;
alias CACA_CONIO_CYAN = CACA_CONIO_COLORS.CACA_CONIO_CYAN;
alias CACA_CONIO_RED = CACA_CONIO_COLORS.CACA_CONIO_RED;
alias CACA_CONIO_MAGENTA = CACA_CONIO_COLORS.CACA_CONIO_MAGENTA;
alias CACA_CONIO_BROWN = CACA_CONIO_COLORS.CACA_CONIO_BROWN;
alias CACA_CONIO_LIGHTGRAY = CACA_CONIO_COLORS.CACA_CONIO_LIGHTGRAY;
alias CACA_CONIO_DARKGRAY = CACA_CONIO_COLORS.CACA_CONIO_DARKGRAY;
alias CACA_CONIO_LIGHTBLUE = CACA_CONIO_COLORS.CACA_CONIO_LIGHTBLUE;
alias CACA_CONIO_LIGHTGREEN = CACA_CONIO_COLORS.CACA_CONIO_LIGHTGREEN;
alias CACA_CONIO_LIGHTCYAN = CACA_CONIO_COLORS.CACA_CONIO_LIGHTCYAN;
alias CACA_CONIO_LIGHTRED = CACA_CONIO_COLORS.CACA_CONIO_LIGHTRED;
alias CACA_CONIO_LIGHTMAGENTA = CACA_CONIO_COLORS.CACA_CONIO_LIGHTMAGENTA;
alias CACA_CONIO_YELLOW = CACA_CONIO_COLORS.CACA_CONIO_YELLOW;
alias CACA_CONIO_WHITE = CACA_CONIO_COLORS.CACA_CONIO_WHITE;

/** \brief DOS cursor modes
 *
 *  This enum lists the cursor mode values for the DOS conio.h compatibility
 *  layer.
 */
enum CACA_CONIO_CURSOR {
  CACA_CONIO__NOCURSOR = 0,
  CACA_CONIO__SOLIDCURSOR = 1,
  CACA_CONIO__NORMALCURSOR = 2
}

alias CACA_CONIO__NOCURSOR = CACA_CONIO_CURSOR.CACA_CONIO__NOCURSOR;
alias CACA_CONIO__SOLIDCURSOR = CACA_CONIO_CURSOR.CACA_CONIO__SOLIDCURSOR;
alias CACA_CONIO__NORMALCURSOR = CACA_CONIO_CURSOR.CACA_CONIO__NORMALCURSOR;

/** \brief DOS video modes
 *
 *  This enum lists the video mode values for the DOS conio.h compatibility
 *  layer.
 */
enum CACA_CONIO_MODE {
  CACA_CONIO_LASTMODE = -1,
  CACA_CONIO_BW40 = 0,
  CACA_CONIO_C40 = 1,
  CACA_CONIO_BW80 = 2,
  CACA_CONIO_C80 = 3,
  CACA_CONIO_MONO = 7,
  CACA_CONIO_C4350 = 64
}

alias CACA_CONIO_LASTMODE = CACA_CONIO_MODE.CACA_CONIO_LASTMODE;
alias CACA_CONIO_BW40 = CACA_CONIO_MODE.CACA_CONIO_BW40;
alias CACA_CONIO_C40 = CACA_CONIO_MODE.CACA_CONIO_C40;
alias CACA_CONIO_BW80 = CACA_CONIO_MODE.CACA_CONIO_BW80;
alias CACA_CONIO_C80 = CACA_CONIO_MODE.CACA_CONIO_C80;
alias CACA_CONIO_MONO = CACA_CONIO_MODE.CACA_CONIO_MONO;
alias CACA_CONIO_C4350 = CACA_CONIO_MODE.CACA_CONIO_C4350;

/** \brief DOS text area information
 *
 *  This structure stores text area information for the DOS conio.h
 *  compatibility layer.
 */
struct caca_conio_text_info {
  ubyte winleft; /**< left window coordinate */
  ubyte wintop; /**< top window coordinate */
  ubyte winright; /**< right window coordinate */
  ubyte winbottom; /**< bottom window coordinate */
  ubyte attribute; /**< text attribute */
  ubyte normattr; /**< normal attribute */
  ubyte currmode; /**< current video mode:
         BW40, BW80, C40, C80, or C4350 */
  ubyte screenheight; /**< text screen's height */
  ubyte screenwidth; /**< text screen's width */
  ubyte curx; /**< x-coordinate in current window */
  ubyte cury; /**< y-coordinate in current window */
}

/** \brief DOS direct video control */
extern __gshared int caca_conio_directvideo;

/** \brief DOS scrolling control */
extern __gshared int caca_conio__wscroll;

/** \defgroup conio libcaca DOS conio.h compatibility layer
 *
 *  These functions implement DOS-like functions for high-level text
 *  operations.
 *
 *  @{ */
char* caca_conio_cgets(char* str);
void caca_conio_clreol();
void caca_conio_clrscr();
int caca_conio_cprintf(const(char)* format, ...);
int caca_conio_cputs(const(char)* str);
int caca_conio_cscanf(char* format, ...);
void caca_conio_delay(uint);
void caca_conio_delline();
int caca_conio_getch();
int caca_conio_getche();
char* caca_conio_getpass(const(char)* prompt);
int caca_conio_gettext(int left, int top, int right, int bottom, void* destin);
void caca_conio_gettextinfo(caca_conio_text_info* r);
void caca_conio_gotoxy(int x, int y);
void caca_conio_highvideo();
void caca_conio_insline();
int caca_conio_kbhit();
void caca_conio_lowvideo();
int caca_conio_movetext(int left, int top, int right, int bottom, int destleft, int desttop);
void caca_conio_normvideo();
void caca_conio_nosound();
int caca_conio_printf(const(char)* format, ...);
int caca_conio_putch(int ch);
int caca_conio_puttext(int left, int top, int right, int bottom, void* destin);
void caca_conio__setcursortype(int cur_t);
void caca_conio_sleep(uint);
void caca_conio_sound(uint);
void caca_conio_textattr(int newattr);
void caca_conio_textbackground(int newcolor);
void caca_conio_textcolor(int newcolor);
void caca_conio_textmode(int newmode);
int caca_conio_ungetch(int ch);
int caca_conio_wherex();
int caca_conio_wherey();
void caca_conio_window(int left, int top, int right, int bottom);
/*  @} */

/* Legacy stuff from beta versions, will probably disappear in 1.0 */

/* Aliases from old libcaca functions */
ssize_t caca_import_memory(caca_canvas_t*, const(void)*, size_t, const(char)*);
ssize_t caca_import_file(caca_canvas_t*, const(char)*, const(char)*);
void* caca_export_memory(const(caca_canvas_t)*, const(char)*, size_t*);

// enum caca_get_cursor_x = caca_wherex;
// enum caca_get_cursor_y = caca_wherey;

/* __CACA_H__ */
