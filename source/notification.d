import std.format;
import std.net.curl;
import toml;

/**
   Send a ntfy notification to a given topic
 */
void send_notification(TOMLValue ntfy_conf, string notif_text)
{
  auto client = HTTP();
  client.method = HTTP.Method.post;
  client.url = format("%s/%s", ntfy_conf["url"].str(), ntfy_conf["topic"].str());
  // client.authenticationMethod = HTTP.AuthMethod.bearer;
  // client.setAuthentication(ntfy_conf["token"].str, "");
  client.addRequestHeader("Authorization", "Bearer " ~ ntfy_conf["token"].str());
  client.addRequestHeader("X-Title", "Pomidor");
  client.addRequestHeader("X-Priority", "5");
  client.postData(notif_text);
  client.perform();
}
