import timings;

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
