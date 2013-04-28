local beautiful = require("beautiful")
awful.rules = require("awful.rules")
s = screen.count()

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = true,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule_any = { class = { "MPlayer", "pinetry", "gimp", "Gimp", "plugin-container", "lxrandr", "Plugin-container" } },
      properties = { floating = true } },
    { rule = { name = "alsamixer" },
      properties = { floating = true  } },
    { rule_any = { name = { "plasma-desktop", "krunner" } },
      properties = { focusable = false  } },
    { rule_any = { class = { "clementine", "Clementine" } },
      properties = { tag = tags[1][5] } },
    { rule = { class = "Firefox" },
       properties = { tag = tags[s][1] } },
    { rule = { class = "Pidgin" },
       properties = { tag = tags[1][1] } },
    { rule = { class = "Eclipse" },
       properties = { tag = tags[s][2] } },
}
-- }}}
