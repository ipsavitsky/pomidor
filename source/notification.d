import std.format;
import std.net.curl;
import config;

/**
   Send a ntfy notification to a given topic
 */
void send_notification(Ntfy ntfy_conf, string notif_text)
{
  auto client = HTTP();
  client.method = HTTP.Method.post;
  client.url = format("%s/%s", ntfy_conf.url, ntfy_conf.topic);
  client.addRequestHeader("Authorization", "Bearer " ~ ntfy_conf.token);
  client.addRequestHeader("X-Title", "Pomidor");
  client.addRequestHeader("X-Priority", "5");
  client.postData(notif_text);
  client.onReceive = (ubyte[] data) { return data.length; };
  client.perform();
}
