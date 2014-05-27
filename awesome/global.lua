local awful = require("awful")
local beautiful = require("beautiful")
local gears = require("gears")

-- This is used later as the default terminal and editor to run.
terminal = "urxvt"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor


-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.magnifier,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.floating
--    awful.layout.suit.tile.left,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.max,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
}


-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "[1]", "[2]", "[3]", "[4]", "[5]", "[6]", "[7]", "[8]" }, s, layouts[1])
end
-- }}}


-- Themes define colours, icons, and wallpapers
beautiful.init("/usr/share/awesome/themes/wombat/theme.lua")
-- {{{ Wallpaper
-- for s = 1, screen.count() do
--    gears.wallpaper.maximized("/usr/share/awesome/themes/wombat/background.jpg", s, true)
-- end
-- }}}
