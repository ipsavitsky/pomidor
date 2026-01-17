import std.algorithm.searching : canFind;
import std.file;
import std.stdio;
import std.typecons : Nullable;
import toml;

version (unittest) {
  import unit_threaded;
}

enum ConfigType {
  Ntfy,
  Native
}

class FieldNotFoundException : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__)
  {
    super(msg, file, line);
  }
}

class InvalidValueException : Exception {
  this(string msg, string file = __FILE__, size_t line = __LINE__)
  {
    super(msg, file, line);
  }
}

struct NtfyConfig {
  string url;
  string topic;
  string token;
}

struct Config {
  ConfigType type;
  Nullable!NtfyConfig ntfy;
}

NtfyConfig parseNtfyConfig(TOMLDocument config)
{
  if (!config.keys.canFind("ntfy")) {
    throw new FieldNotFoundException("Missing 'ntfy' section");
  }
  auto ntfyConfig = config["ntfy"].table;
  if (!ntfyConfig.keys.canFind("url")) {
    throw new InvalidValueException("Missing 'url' field");
  }
  if (!ntfyConfig.keys.canFind("topic")) {
    throw new InvalidValueException("Missing 'topic' field");
  }
  return NtfyConfig(ntfyConfig["url"].str(), ntfyConfig["topic"].str(),
      parseNtfyToken(ntfyConfig));
}

string parseNtfyToken(TOMLValue[string] ntfyConfig)
{
  if (ntfyConfig.keys.canFind("token")) {
    return ntfyConfig["token"].str();
  } else if (ntfyConfig.keys.canFind("token_file")) {
    return readText(ntfyConfig["token_file"].str());
  } else {
    throw new InvalidValueException("Missing 'token' or 'token_file' field");
  }
}

ConfigType parseType(TOMLDocument config)
{
  if (!config.keys.canFind("type")) {
    throw new FieldNotFoundException("Missing 'type' field");
  } else {
    switch (config["type"].str()) {
    case "ntfy":
      return ConfigType.Ntfy;
    case "native":
      return ConfigType.Native;
    default:
      throw new InvalidValueException("Invalid 'type' field");
    }
  }
}

Config parseConfig(string path)
{
  TOMLDocument tomlConf = parseTOML(path);
  ConfigType type = parseType(tomlConf);
  Config res;
  res.type = type;

  final switch (type) {
  case ConfigType.Ntfy:
    res.ntfy = parseNtfyConfig(tomlConf);
    break;
  case ConfigType.Native:
    res.ntfy.nullify();
    break;
  }

  return res;
}

@("parseNtfyToken with direct token")
unittest {
  auto ntfyConfig = ["token": TOMLValue("test-token")];
  parseNtfyToken(ntfyConfig).shouldEqual("test-token");
}

@("parseNtfyToken with token file")
unittest {
  auto tmpFile = "/tmp/test_token_file";
  std.file.write(tmpFile, "file-token");
  scope (exit)
    std.file.remove(tmpFile);

  auto ntfyConfig = ["token_file": TOMLValue(tmpFile)];
  parseNtfyToken(ntfyConfig).shouldEqual("file-token");
}

@("parseNtfyToken without token")
unittest {
  auto ntfyConfig = cast(TOMLValue[string]) null;
  parseNtfyToken(ntfyConfig).shouldThrow!InvalidValueException();
}
