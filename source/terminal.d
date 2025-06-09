import std.stdio;
import caca;
import std.math;
import core.thread;
import std.conv;
import std.string;

void draw_clock(caca_canvas_t* cv, float progress)
{
  auto angle = progress * PI;
  caca_draw_circle(cv, 20, 20, 10, '#');
  auto x = 10 * sin(-2 * angle);
  auto y = 10 * cos(-2 * angle);
  caca_draw_line(cv, 20, 20, cast(int)(20 - x), cast(int)(20 - y), '#');
}

void draw_stats(caca_canvas_t* cv, int left)
{
  auto mins = left / 60;
  auto secs = left % 60;
  auto st = format("%dm%02ds left in this iteration", mins, secs);
  caca_put_str(cv, 40, 20, toStringz(st));
}

void draw_help(caca_canvas_t* cv) {
  caca_put_str(cv, 5, 33, "Press n for next phase");
  caca_put_str(cv, 5, 34, "Press q to quit");
}

void draw_canvas(caca_canvas_t* cv, int current, int total)
{
  caca_clear_canvas(cv);
  float f = cast(float) current / total;
  draw_clock(cv, f);
  draw_stats(cv, total - current);
  draw_help(cv);
}

void draw_inter_canvas(caca_canvas_t* cv) {
  caca_clear_canvas(cv);
  caca_put_str(cv, 0, 0, "Are you ready to proced?");
  caca_put_str(cv, 0, 1, "Press any key to continue");
}
