import std.format;
import std.net.curl;
import std.string;
import std.typecons : Nullable;
import config;
import libnotify;

/**
   Send a ntfy notification to a given topic
 */
void send_notification_ntfy(NtfyConfig ntfy_conf, string notif_text)
{
  auto client = HTTP();
  client.method = HTTP.Method.post;
  client.url = format("%s/%s", ntfy_conf.url, ntfy_conf.topic);
  if (ntfy_conf.token.length > 0) {
    client.addRequestHeader("Authorization", "Bearer " ~ ntfy_conf.token);
  }
  client.addRequestHeader("X-Title", "Pomidor");
  client.addRequestHeader("X-Priority", "5");
  client.postData(notif_text);
  client.onReceive = (ubyte[] data) { return data.length; };
  client.perform();
}

/**
   Send a desktop notification using libnotify
 */
void send_notification_desktop(string notif_text)
{
  notify_init("Pomidor");
  scope (exit)
    notify_uninit();

  auto notification = notify_notification_new("Pomidor", notif_text.toStringz, null);
  if (notification != null) {
    notify_notification_show(notification, null);
  }
}

void send_notification(Config conf, string notif_text)
{
  final switch (conf.type) {
  case ConfigType.Ntfy:
    send_notification_ntfy(conf.ntfy.get, notif_text);
    break;
  case ConfigType.Native:
    send_notification_desktop(notif_text);
    break;
  }
}
