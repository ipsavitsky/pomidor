import std.stdio;
import std.file;
import std.string;
import std.format;
import std.concurrency;
import requests;
import deimos.ncurses;
import core.thread;
import std.conv;
import toml;
import input;
import notification;

const int working_period = 25;
const int resting_period = 5;
const int long_resting_period = 25 * 60;

enum CountdownMode {
  Working,
  Resting,
  LongResting
}

int second_period(CountdownMode mode)
{
  final switch (mode) {
  case CountdownMode.Working:
    return working_period;
  case CountdownMode.Resting:
    return resting_period;
  case CountdownMode.LongResting:
    return long_resting_period;
  }
}

CountdownMode next_mode(CountdownMode currentMode)
{
  final switch (currentMode) {
  case CountdownMode.Working:
    return CountdownMode.Resting;
  case CountdownMode.Resting:
  case CountdownMode.LongResting:
    return CountdownMode.Working;
  }
}

string message(CountdownMode currentMode)
{
  final switch (currentMode) {
  case CountdownMode.Working:
    return "We're done working on this; time to cool down";
  case CountdownMode.Resting:
  case CountdownMode.LongResting:
    return "Enough resting; time to get back to work";
  }
}

class App {
  this()
  {
    mode = CountdownMode.Working;
  }

  void next()
  {
    mode = next_mode(mode);
  }

  void draw_screen(int secondsLeft)
  {
    auto status_string = format("Please wait %dm%02ds seconds until this is over...",
        secondsLeft / 60, secondsLeft % 60);
    printw(toStringz(status_string));
  }

private:
  CountdownMode mode;
}

void main()
{
  auto config = parseTOML(cast(string) read("./config.toml"));
  initscr();

  scope (exit)
    endwin();

  App state = new App();

  spawn(&input.handleInput);

  while (true) {
    foreach_reverse (n; 0 .. second_period(state.mode)) {
      clear();
      state.draw_screen(n);
      refresh();
      Thread.sleep(dur!("seconds")(1));
    }

    notification.send_notification(config["ntfy"], message(state.mode));

    state.next();
  }
}
