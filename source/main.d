import toml;
import std.process;
import std.stdio;
import std.file;
import std.format;
import app;

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
