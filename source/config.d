import toml;

struct Ntfy {
  string url;
  string topic;
  string token;
}

struct Config {
   Ntfy ntfy;
}

Config parseConfig(string path) {
  TOMLDocument tomlConf = parseTOML(path);
  Config res = {
    ntfy: {
      url: tomlConf["ntfy"]["url"].str(),
      topic: tomlConf["ntfy"]["topic"].str(),
      token: tomlConf["ntfy"]["token"].str()
    },
  };

  return res;
}
