import std.concurrency;
import deimos.ncurses;

void handleInput()
{
  while (true) {
    auto ch = getch();
    ownerTid.send(ch);
  }
}
