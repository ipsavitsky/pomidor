import deimos.ncurses;
import std.math;

class Clock {
private:
  bool[20][20] field = false;

  bool in_bounds(int x)
  {
    return x >= 0 && x < 20;
  }

public:
  void draw()
  {
    draw_circle(10, 10, 10);
    foreach (line; field) {
      foreach (symbol; line) {
        if (symbol) {
          printw("*");
        } else {
          printw(" ");
        }
      }
      printw("\n");
    }
  }

  void draw_circle(int cx, int cy, int r)
  {
    double minAngle = acos(1 - 1 / cast(double)(r));
    for (double angle = 0; angle <= 360; angle += minAngle) {
      int x = cast(int)(r * cos(angle));
      int y = cast(int)(r * sin(angle));

      if (in_bounds(x + cx) && in_bounds(y + cy)) {
        field[x + cx][y + cy] = true;
      }
    }
  }
}
