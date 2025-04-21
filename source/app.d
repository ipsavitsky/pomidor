import std.stdio;
import std.file;
import std.string;
import std.format;
import std.concurrency;
import std.process;
import requests;
import deimos.ncurses;
import core.thread;
import core.stdc.stdlib;
import std.conv;
import toml;
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
private:
  CountdownMode mode;
  TOMLDocument config;

public:
  this(TOMLDocument conf)
  {
    mode = CountdownMode.Working;
    config = conf;
    initscr();
    cbreak();
    noecho();
    timeout(0);
    keypad(stdscr, 1);
  }

  ~this()
  {
    endwin();
  }

  void run()
  {
    outer: while (true) {
      foreach (a; screen_generator(second_period(mode))) {
        writeln("input...");
        immutable int ch = getch();
        if (ch == 'q') {
          break outer;
        }
        refresh();
      }
      if (config["ntfy"] != null) {
        send_notification(config["ntfy"], message(mode));
      }
      next();
    }
  }

private:
  void next()
  {
    mode = next_mode(mode);
  }

  void draw_screen(int secondsLeft)
  {
    auto status_string = format("Please wait %dm%02ds seconds until this is over...\n",
        secondsLeft / 60, secondsLeft % 60);
    printw(toStringz(status_string));
    printw(toStringz("Press q to quit"));
  }

  Generator!int screen_generator(int seconds)
  {
    return new Generator!int({
      foreach_reverse (n; 0 .. seconds) {
        clear();
        draw_screen(n);
        yield(1);
        Thread.sleep(dur!("seconds")(1));
      }
    });
  }
}

void main()
{
  TOMLDocument config;
  try {
    auto config_home = environment.get("XDG_CONFIG_HOME");
    if (config_home is null) {
      writeln("no xdg config home set");
      return;
    }
    config = parseTOML(cast(string) read(format("%s/pomidor/config.toml", config_home)));
  } catch (std.file.FileException) {
    writeln("Could not find config file");
    return;
  }

  App state = new App(config);

  state.run();

  // I have to clean up explicitly??
  destroy(state);
  return;
}
