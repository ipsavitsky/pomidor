import std.process;
import std.stdio;
import std.file;
import std.format;
import app;
import config;

void main()
{
  config.Config config;
  try {
    auto home = environment.get("HOME");
    if (home is null) {
      writeln("HOME environment variable not set");
      return;
    }
    config = parseConfig(readText(format("%s/.config/pomidor/config.sdl", home)));
  } catch (std.file.FileException) {
    writeln("Could not find config file");
    return;
  }

  App state = new App(config);

  state.run();

  destroy(state);
  return;
}
