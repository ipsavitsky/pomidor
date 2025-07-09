import std.file;
import std.stdio;
import toml;

struct Ntfy {
  string url;
  string topic;
  string token;
}

struct Config {
   Ntfy ntfy;
}

string parseNtfyToken(TOMLDocument config) {
  if ("token" in config["ntfy"]) {
    return config["ntfy"]["token"].str();
  } else if ("token_file" in config["ntfy"]) {
    return readText(config["ntfy"]["token_file"].str());
  } else return null;
}

Config parseConfig(string path) {
  TOMLDocument tomlConf = parseTOML(path);
  Config res = {
    ntfy: {
      url: tomlConf["ntfy"]["url"].str(),
      topic: tomlConf["ntfy"]["topic"].str(),
      token: parseNtfyToken(tomlConf),
    },
  };

  return res;
}
