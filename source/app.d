import std.conv;
import std.stdio;
import std.file;
import std.string;
import std.format;
import std.concurrency;
import std.process;
import deimos.ncurses;
import core.thread;
import core.stdc.stdlib;
import toml;
import notification;

/**
   Time it takes to work, in seconds
 */
const int working_period = 25 * 60;

/**
   Time it takes to rest, in seconds
 */
const int resting_period = 5 * 60;

/**
   Time it takes to long rest (usually, every forth), in seconds
 */
const int long_resting_period = 25 * 60;

/**
   Enum to represent the current state of the timer
 */
enum CountdownMode {
  Working,
  Resting,
  LongResting
}

/**
   Convert mode to time period
 */
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

/**
   Convert mode to a message string when switching from mode to mode
 */
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

/**
   Reflect mode to string
 */
string mode_to_string(CountdownMode mode)
{
  final switch (mode) {
  case CountdownMode.Working:
    return "working";
  case CountdownMode.Resting:
    return "resting";
  case CountdownMode.LongResting:
    return "long resting";
  }
}

/**
   Class that represent the current app state
 */
class App {
private:
  CountdownMode mode = CountdownMode.Working;
  TOMLDocument config;
  int periodCount = 1;

public:
  /**
     Initialize the app with a config
   */
  this(TOMLDocument conf)
  {
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

  /**
     Run the app with the current configuration
   */
  void run()
  {
    outer: while (true) {
      countdown: foreach (a; screen_generator(second_period(mode))) {
        immutable int ch = getch();
        switch (ch) {
        case 'q':
          break outer;
        case 'n':
          break countdown;
        default:
          break;
        }
        refresh();
      }
      if (config["ntfy"] != null) {
        send_notification(config["ntfy"], message(mode));
      }

      periodCount++;
      draw_inter_screen();
      refresh();
      timeout(-1);
      input: while (true) {
        immutable int ch = getch();
        switch (ch) {
        case 'q':
          break outer;
        case 'n':
          break input;
        default:
          break;
        }
      }

      next();
      timeout(0);
    }
  }

private:

  CountdownMode next_mode(CountdownMode currentMode)
  {
    final switch (currentMode) {
    case CountdownMode.Working:
      if (periodCount % 8 == 0) {
        return CountdownMode.LongResting;
      } else {
        return CountdownMode.Resting;
      }
    case CountdownMode.Resting:
    case CountdownMode.LongResting:
      return CountdownMode.Working;
    }
  }

  void next()
  {
    mode = next_mode(mode);
  }

  void draw_inter_screen()
  {
    clear();
    printw(toStringz(format("Press n for next phase (%s, period %d)\n",
        mode_to_string(next_mode(mode)), periodCount)));
    printw(toStringz("Press q to quit"));
  }

  void draw_screen(int secondsLeft)
  {
    clear();
    auto status_string = format("You have %dm%02ds of %s left\n",
        secondsLeft / 60, secondsLeft % 60, mode_to_string(mode));
    printw(toStringz(status_string));
    printw(toStringz("Press n to skip this phase\n"));
    printw(toStringz("Press q to quit"));
  }

  Generator!int screen_generator(int seconds)
  {
    return new Generator!int({
      foreach_reverse (n; 0 .. seconds) {
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
