extern (C) {
  caca_display_t* caca_create_display(caca_canvas_t*);
  caca_canvas_t* caca_get_canvas(caca_display_t*);
  int caca_set_display_title(caca_display_t*, const char*);
  int caca_set_color_ansi(caca_canvas_t*, uint16_t, uint16_t);
  int caca_put_str(caca_canvas_t*, int, int, const char*);
  int caca_refresh_display(caca_display_t*);
  int caca_get_event(caca_display_t*, int, caca_event_t*, int);
  int caca_free_display(caca_display_t*);
}

void draw_with_shit()
{
  caca_canvas_t* cv;
  caca_display_t* dp;
  caca_event_t ev;
  dp = caca_create_display(NULL);
  if (!dp)
    return 1;
  cv = caca_get_canvas(dp);
  caca_set_display_title(dp, "Hello!");
  caca_set_color_ansi(cv, CACA_BLACK, CACA_WHITE);
  caca_put_str(cv, 0, 0, "This is a message");
  caca_refresh_display(dp);
  caca_get_event(dp, CACA_EVENT_KEY_PRESS, &ev, -1);
  caca_free_display(dp);
}
