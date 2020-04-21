-- requires: vicious-git lain-git awesome-freedesktop-git
-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget
-- Enable VIM help for hotkeys widget when client with matching name is opened:
require("awful.hotkeys_popup.keys.vim")

-- enable awesome-client
require("awful.remote")

-- Custom stuff
local screens = require("screens")
local lain = require("lain")

local xrandr = require("xrandr")
xrandr.auto()

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end
-- }}}

-- {{{ Variable definitions
-- Themes define colours, icons, font and wallpapers.
beautiful.init(awful.util.get_themes_dir() .. "zenburn/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "konsole"
editor = os.getenv("EDITOR") or "vim"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts =
{
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.magnifier,
    awful.layout.suit.floating,
    awful.layout.suit.corner.nw
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
--    awful.layout.suit.max,
--    awful.layout.suit.fair.horizontal,
--    awful.layout.suit.max.fullscreen,
--    awful.layout.suit.tile.bottom,
--    awful.layout.suit.spiral,
--    awful.layout.suit.spiral.dwindle,
}

local default_layout = awful.layout.layouts[1]
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

-- Run or raise client based on its class name
function ror_class(cmd, cls, instance)
    instance = instance or nil
    local matcher = function (c)
        if instance == nil then
            return awful.rules.match(c, {class = cls})
        else
            return awful.rules.match(c, {class = cls, instance = instance})
        end
    end
    awful.client.run_or_raise(cmd, matcher)
end

local function lower_volume()
    local cmd = [[amixer -D pulse sset Master 5%- | grep "Front Left: Playback" | sed "s/.*\[\([0-9]\+%\)\].*/Volume \1/"]]
    awful.spawn.easy_async_with_shell(cmd, function(out)
        naughty.notify({ text = out, timeout = 1, ontop = false })
    end)
end
local function raise_volume()
    local cmd = [[amixer -D pulse sset Master 5%+ | grep "Front Left: Playback" | sed "s/.*\[\([0-9]\+%\)\].*/Volume \1/"]]
    awful.spawn.easy_async_with_shell(cmd, function(out)
        naughty.notify({ text = out, timeout = 1, ontop = false })
    end)
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
local freedesktop = require("freedesktop")
myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", string.format("%s -e %s %s", terminal, editor, awesome.conffile) },
    { "restart", awesome.restart },
    { "quit", function() awesome.quit() end },
    { "poweroff", "systemctl poweroff" }
}
mymainmenu = freedesktop.menu.build({
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        -- other triads can be put here
    },
    after = {
        { "Open terminal", terminal },
        -- other triads can be put here
    }
})

-- Icons and Widgets
icons = awful.util.getdir("config") .. "/themes/icons"

mylauncher = awful.widget.launcher({ image = icons .. "/fox.png",
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- Keyboard map indicator and switcher
mykeyboardlayout = awful.widget.keyboardlayout()

-- {{{ Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock()
seperator = wibox.widget.textbox()
seperator:set_text(" | ")
spacer = wibox.widget.textbox()
spacer.width = 6

cpuicon = wibox.widget.imagebox()
-- awful.util.get_themes_dir()
cpuicon:set_image("/usr/share/awesome/themes/icons/zenburn/cpu.png")
cpuicon.bg_align = "middle"
cpuicon.width = 8

batticon = wibox.widget.imagebox()
batticon:set_image(icons .. "/bat.png")
batticon.bg_align = "middle"
batticon.width = 8

tempicon = wibox.widget.imagebox()
tempicon:set_image(icons .. "/temp.png")
tempicon.bg_align = "middle"
tempicon.width = 8

timeicon = wibox.widget.imagebox()
timeicon:set_image(icons .. "/time.png")
timeicon.bg_align = "middle"
timeicon.width = 8

pulseicon = wibox.widget.imagebox()
pulseicon:set_image(icons .. "/vol.png")
pulseicon.bg_align = "middle"
pulseicon.width = 8

--cpuinfo = wibox.widget.textbox()
--cpuinfo:set_align("right")
cpuinfo = wibox.widget.graph()
cpuinfo:set_background_color("#000000")
cpuinfo:set_width(35)
cpuinfo:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 },
stops = { {0, "#FF5656"}, {0.5, "#88A175"}, {1, "#AECF96" }}})
battinfo = wibox.widget.textbox()
tempinfo = wibox.widget.textbox()

volinfo = wibox.widget.textbox()
volbuttons = awful.util.table.join(
        awful.button({ }, 1, function() awful.spawn.with_shell("urxvt -name alsamixerfloat -e alsamixer", mouse.screen) end)
        )
volinfo:buttons(volbuttons)

timebuttons = awful.util.table.join(
        awful.button({ }, 1, function() awful.spawn("hamster-time-tracker", false, mouse.screen) end)
        )
timeicon:buttons(timebuttons)

pulseicon:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.spawn("pavucontrol", false,  mouse.screen) end)
))

local vicious = require("vicious-git")
--vicious.register(cpuinfo, vicious.widgets.cpu, "$2% / $3% / $4% / $5%")
vicious.register(cpuinfo, vicious.widgets.cpu, "$1")
--cpuinfo = wibox.layout.constraint(cpuinfo, "exact", 135, nil)
vicious.register(battinfo, vicious.widgets.bat, "$2%$1", 60, "BAT0")
vicious.register(tempinfo, vicious.widgets.thermal, "$1°C", 5, "thermal_zone0")
-- vicious.register(volinfo, vicious.widgets.volume, "$2 $1%", 1, "Master")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t)
                                              if client.focus then
                                                  client.focus:move_to_tag(t)
                                              end
                                          end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t)
                                              if client.focus then
                                                  client.focus:toggle_tag(t)
                                              end
                                          end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
                )

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() and c.first_tag then
                                                      c.first_tag:view_only()
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, client_menu_toggle_fn()),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                          end))

local function set_wallpaper(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    -- Quake application
    s.quake = lain.util.quake({ app = terminal, width = 1, height = 1.0})

    -- Wallpaper
    set_wallpaper(s)

    -- Each screen has its own tag table.
    if s == screen.primary then
        awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
    else
        -- awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
        awful.tag({ "1" }, s, awful.layout.layouts[1])
    end

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
            mylauncher,
            s.mytaglist,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            cpuicon,
            cpuinfo,
            separator,
            batticon,
            battinfo,
            separator,
            tempicon,
            tempinfo,
            separator,
            volinfo,
            pulseicon,
            separator,
            mytextclock,
            s.mylayoutbox,
        },
    }
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings

globalkeys = gears.table.join(
    awful.key({ modkey,           }, "h",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "s",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next by index", group = "client"}
    ),
    awful.key({ modkey,           }, "w",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous by index", group = "client"}
    ),
    -- awful.key({ modkey,           }, "w", function () mymainmenu:show() end,
    --          {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "s", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "w", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "s", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "w", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "t", function () awful.spawn(terminal) end),
    awful.key({ modkey,           }, "e", function () awful.spawn("krunner") end),
    awful.key({ modkey,           }, "g", function () awful.spawn("dolphin") end),
    awful.key({ modkey, }, 'F1', function () ror_class("google-chrome-stable", "Google-chrome", "google-chrome") end),
    awful.key({ modkey, }, 'F4', function () ror_class("thunderbird", "Thunderbird") end),
    awful.key({ modkey, }, 'F5', function () ror_class("clementine", "Clementine") end),
    awful.key({ modkey, }, 'F8', function () ror_class("pavucontrol", "Pavucontrol") end),

    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "d",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "a",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "a",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "d",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "a",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "d",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(awful.layout.layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(awful.layout.layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", function () awful.client.restore() end),
    -- awful.key({ modkey }, "q", function () mousefinder:find() end),

    -- Prompt
    awful.key({ modkey }, "r",     function () mouse.screen.mypromptbox:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  s.mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- custom hotkeys
    awful.key({}, "XF86ModeLock",   function () awful.util.spawn.with_shell("dbus-send --session --dest=org.freedesktop.ScreenSaver --type=method_call /ScreenSaver org.freedesktop.ScreenSaver.Lock") end),
    awful.key({}, "XF86Standby",   function () awful.util.spawn.with_shell("xset dpms force off") end),
    awful.key({}, "XF86Launch1",   function () awful.util.spawn.with_shell("/home/fixje/bin/display-disconnect.sh") end),
    awful.key({}, "XF86WebCam", function () awful.util.spawn.with_shell("/home/fixje/bin/display-setup.sh") end),
    awful.key({}, "XF86Launch4", function () awful.util.spawn("sudo /usr/local/bin/bluetooth-toggle.sh") 
end),
    awful.key({}, "XF86Launch5", function () awful.util.spawn("/usr/local/bin/touchpad-toggle.sh") end),
    awful.key({}, "XF86LaunchA", function () awful.screen.focused().quake:toggle() end),
    awful.key({ modkey }, "l",   function () awful.spawn.with_shell("xlock -mode forest") end),
    awful.key({}, "XF86LaunchA",   function () xrandr.xrandr() end),
    awful.key({ modkey }, "XF86LaunchA", function () drop("urxvt -name urxvt_drop2 -e $SHELL -ci 'ipython2'", "bottom", "left", 0.50, 0.30, true, screens.main) end),
    awful.key({ }, "XF86AudioLowerVolume", function () lower_volume() end),
    awful.key({ }, "XF86AudioRaiseVolume", function () raise_volume() end),
    awful.key({ }, "XF86AudioMute", function () awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle") end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Control"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey, "Control", "Shift" }, "w",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
     }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Do not add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
    { rule = { name = "alsamixer" },
      properties = { floating = true  } },
    { rule_any = { class = { "clementine", "Clementine" } },
      properties = { tag = "5" } },
    { rule = { class = "Firefox" },
       properties = { tag = "1" } },
    { rule_any = { class = { "Pidgin", "Kopete", "Skype" } },
       properties = { tag = "7" } },
    { rule_any = { class = { "Pavucontrol" },
         callback = function(c)
              c:geometry( { width = 600 , height = 500 } )
       end,
    },
       properties = { floating = true } },
    { rule_any = { class = { "Google-chrome" } },
       properties = { tag = "1", floating = false, maximized = false }
    },
    { rule = { class = "jetbrains-idea" },
       properties = { tag = "2", maximized = false } },
    { rule = { class = "yakuake" },
      properties = { floating = true, maximized = true }
    },
    { rule = { class = "Thunderbird" },
       properties = { tag = "4", maximized = false, floating = false } },
   -- plasma widgets
   {
       rule = { class = "Plasma-desktop" },
       properties = { floating = true },
       callback = function(c)
           c:geometry( { width = 600 , height = 500 } )
       end,
   },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
        client.focus = c
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
awful.spawn("nm-applet")
awful.spawn("yakuake")
-- left-handed mouse
-- awful.spawn('xmodmap -e "pointer = 3 2 1"')
-- }}}
--
