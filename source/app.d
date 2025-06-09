import std.string;
import std.concurrency;
import core.thread;
import toml;
import terminal;
import notification;
import caca;
import utils;

/**
   Class that represent the current app state
 */
class App {
private:
  CountdownMode mode = CountdownMode.Working;
  TOMLDocument config;
  int periodCount = 1;
  caca_display_t* dp;
  caca_canvas_t* cv;

public:
  /**
     Initialize the app with a config
   */
  this(TOMLDocument conf)
  {
    config = conf;
    dp = caca_create_display_with_driver(null, "ncurses"); // we're keeping this for now, but x11 output might be pretty cool idk
    if (!dp)
      return;
    cv = caca_get_canvas(dp);
  }

  ~this()
  {
    caca_free_display(dp);
  }

  /**
     Run the app with the current configuration
   */
  void run()
  {
    while (true) {
      auto period = second_period(mode);
      caca_event_t ev;
      current_loop: foreach (s; countdown(period)) {
        draw_canvas(cv, s, period);
        caca_refresh_display(dp);
        if (caca_get_event(dp, CACA_EVENT_KEY_PRESS, &ev, 0)) {
          switch (caca_get_event_key_ch(&ev)) {
          case 'q':
            return;
          case 'n':
            break current_loop;
          default:
            break;
          }
        }
      }
      send_notification(config["ntfy"], message(mode));
      draw_inter_canvas(cv);
      caca_refresh_display(dp);
      downtime_loop: while(true) {
	caca_get_event(dp, CACA_EVENT_KEY_PRESS, &ev, -1);
	switch (caca_get_event_key_ch(&ev)) {
	case 'q':
	  return;
	case 'n':
	  break downtime_loop;
	default:
	  break;
	}
      }
      next();
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

  Generator!int countdown(int total_seconds)
  {
    return new Generator!int({
      foreach (i; 1 .. total_seconds) {
        yield(i);
        Thread.sleep(dur!("seconds")(1));
      }
    });
  }
}
