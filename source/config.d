import std.algorithm.searching : canFind;
import std.file;
import std.stdio;
import std.conv;
import std.typecons : Nullable;
import utils;
import sdlang;

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
  // TODO: make this a url type
  string url;
  string topic;
  string token;
}

struct Config {
  ConfigType type;
  bool enable_long_rest;
  Split split;
  Nullable!NtfyConfig ntfy;
}

NtfyConfig parseNtfyConfig(Tag config)
{
  Tag ntfy = config.getTag("ntfy");
  if (ntfy is null) {
    throw new FieldNotFoundException("Missing 'ntfy' section");
  }
  return NtfyConfig(ntfy.expectTagValue!string("url"),
      ntfy.expectTagValue!string("topic"), parseNtfyToken(ntfy));
}

string parseNtfyToken(Tag ntfyConfig)
{
  Tag token = ntfyConfig.getTag("token");
  Tag token_file = ntfyConfig.getTag("token_file");
  if (token !is null) {
    return token.expectValue!string();
  } else if (token_file !is null) {
    return readText(token_file.expectValue!string());
  } else {
    throw new InvalidValueException("Missing 'token' or 'token_file' field");
  }
}

ConfigType parseType(Tag config)
{
  immutable string type = config.expectTagValue!string("type");

  switch (type) {
  case "ntfy":
    return ConfigType.Ntfy;
  case "native":
    return ConfigType.Native;
  default:
    throw new InvalidValueException("Invalid 'type' field");
  }
}

Split parseSplit(Tag config)
{
  immutable string split = config.expectTagValue!string("split");

  switch (split) {
  case "short":
    return Split.Short;
  case "long":
    return Split.Long;
  default:
    throw new InvalidValueException("Invalid 'split' field");
  }
}

Config parseConfig(string conf_text)
{
  Tag conf = parseSource(conf_text);
  Config res;
  res.type = parseType(conf);

  final switch (res.type) {
  case ConfigType.Ntfy:
    res.ntfy = parseNtfyConfig(conf);
    break;
  case ConfigType.Native:
    res.ntfy.nullify();
    break;
  }

  res.enable_long_rest = conf.getTagValue("enable_long_rest", false);
  res.split = parseSplit(conf);

  return res;
}

@("simple config passes")
unittest {
  auto test_config = `type "native"
    split "short"
    `;

  Config conf = parseConfig(test_config);
  conf.type.shouldEqual(ConfigType.Native);
  conf.split.shouldEqual(Split.Short);
  conf.enable_long_rest.shouldEqual(false);
  assert(conf.ntfy.isNull());
}

@("ntfy config passes")
unittest {
  auto test_config = `type "ntfy"
    split "short"
    ntfy {
      url "123"
      token "456"
      topic "789"
    }
    `;

  Config conf = parseConfig(test_config);
  conf.ntfy.get.url.shouldEqual("123");
  conf.ntfy.get.token.shouldEqual("456");
  conf.ntfy.get.topic.shouldEqual("789");
}

@("erroneous config throws")
unittest {
  auto test_config = `type "native"
    `;
  parseConfig(test_config).shouldThrow;
}
