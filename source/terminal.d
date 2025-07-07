import std.stdio;
import caca;
import std.math;
import core.thread;
import std.conv;
import std.string;

void draw_clock(caca_canvas_t* cv, int x_cent, int y_cent, int r, float progress)
{
  auto angle = progress * PI;
  caca_draw_circle(cv, x_cent, y_cent, r, '#');
  auto x = r * sin(-2 * angle);
  auto y = r * cos(-2 * angle);
  caca_draw_line(cv, x_cent, y_cent, cast(int)(x_cent - x), cast(int)(y_cent - y), '#');
}

void draw_stats(caca_canvas_t* cv, int x_top_left, int y_top_left, int left)
{
  auto mins = left / 60;
  auto secs = left % 60;
  auto st = format("%dm%02ds left in this iteration", mins, secs);
  caca_put_str(cv, x_top_left, y_top_left, toStringz(st));
}

void draw_help(caca_canvas_t* cv, int x_top_left, int y_top_left)
{
  caca_put_str(cv, x_top_left, y_top_left, "Press n for next phase");
  caca_put_str(cv, x_top_left, y_top_left + 1, "Press q to quit");
}

void draw_canvas(caca_canvas_t* cv, int current, int total)
{
  immutable int w = caca_get_canvas_width(cv);
  immutable int h = caca_get_canvas_height(cv);
  caca_clear_canvas(cv);
  float f = cast(float) current / total;
  immutable int center_w = w / 2;
  immutable int center_h = h / 2;
  draw_clock(cv, center_w - 10 - 20, center_h, 10, f);
  draw_stats(cv, center_w - 10 - 35, center_h + 10 + 5, total - current);
  draw_help(cv, center_w, center_h);
}

void draw_inter_canvas(caca_canvas_t* cv)
{
  immutable int w = caca_get_canvas_width(cv);
  immutable int h = caca_get_canvas_height(cv);
  immutable int center_w = w / 2;
  immutable int center_h = h / 2;

  caca_clear_canvas(cv);
  caca_put_str(cv, center_w - 10, center_h, "Are you ready to proced?");
  caca_put_str(cv, center_w - 10, center_h + 1, "Press n for next phase");
  caca_put_str(cv, center_w - 10, center_h + 2, "Press q to quit");
}
