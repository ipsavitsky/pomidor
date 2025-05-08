import toml;
import requests;
import std.format;

/**
   Send a ntfy notification to a given topic
 */
void send_notification(TOMLValue ntfy_conf, string notif_text)
{
  auto rq = Request();
  rq.addHeaders([
    "Authorization": format("Bearer %s", ntfy_conf["token"].str()),
    "X-Title": "Pomidor",
    "X-Priority": "5"
  ]);
  rq.post(format("%s/%s", ntfy_conf["url"].str(), ntfy_conf["topic"].str()), notif_text);
  // check that response contains code 200
}
