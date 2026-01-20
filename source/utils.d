import timings;
import std.conv;

version (unittest) {
  import unit_threaded;
}

enum Split {
  // 25/5
  Short,
  // 50/10
  Long
}

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
int period_length(Split split, CountdownMode mode)
{
  auto f = 1.0;

  final switch (split) {
  case Split.Short:
    f = 1.0;
    break;
  case Split.Long:
    f = 2.0;
    break;
  }

  final switch (mode) {
  case CountdownMode.Working:
    return to!int(f * working_period);
  case CountdownMode.Resting:
    return to!int(f * resting_period);
  case CountdownMode.LongResting:
    return to!int(f * long_resting_period);
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

@("second_period for Working mode")
unittest {
  period_length(Split.Short, CountdownMode.Working).shouldEqual(25 * 60);
}

@("second_period for Resting mode")
unittest {
  period_length(Split.Short, CountdownMode.Resting).shouldEqual(5 * 60);
}

@("second_period for LongResting mode")
unittest {
  period_length(Split.Short, CountdownMode.LongResting).shouldEqual(25 * 60);
}

@("message for Working mode")
unittest {
  message(CountdownMode.Working).shouldEqual("We're done working on this; time to cool down");
}

@("message for Resting mode")
unittest {
  message(CountdownMode.Resting).shouldEqual("Enough resting; time to get back to work");
}

@("message for LongResting mode")
unittest {
  message(CountdownMode.LongResting).shouldEqual("Enough resting; time to get back to work");
}

@("mode_to_string for Working mode")
unittest {
  mode_to_string(CountdownMode.Working).shouldEqual("working");
}

@("mode_to_string for Resting mode")
unittest {
  mode_to_string(CountdownMode.Resting).shouldEqual("resting");
}

@("mode_to_string for LongResting mode")
unittest {
  mode_to_string(CountdownMode.LongResting).shouldEqual("long resting");
}
