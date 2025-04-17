import std.stdio;
import std.string;
import std.format;
import deimos.ncurses;
import core.thread;

string generate_screen(int sec) {
  return format("Hello ncurses World!\nPlease wait %d seconds until this is over...", sec);
}

void main()
{
    initscr();

    scope (exit)
        endwin();

    for (int i = 10; i >= 0; i--) {
      clear();
      printw(toStringz(generate_screen(i)));
      refresh();
      Thread.sleep(dur!("seconds")(1));
    }
}
