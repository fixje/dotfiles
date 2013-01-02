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
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    { rule = { class = "lxrandr" },
      properties = { floating = true } },
    { rule = { class = "plugin-container" },
      properties = { floating = true } },
    { rule = { name = "alsamixer" },
      properties = { floating = true  } },
    { rule = { class = "clementine" },
      properties = { tag = tags[s][5] } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    { rule = { class = "Firefox" },
       properties = { tag = tags[s][1] } },
    { rule = { class = "Pidgin" },
       properties = { tag = tags[1][1] } },
    { rule = { class = "Eclipse" },
       properties = { tag = tags[s][2] } },
    { rule = { class = "thunar" },
       properties = { tag = tags[s][4] } },
}
-- }}}
