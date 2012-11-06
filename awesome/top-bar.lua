local vicious = require("vicious")

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock({ align = "right" }, " %d.%m.%Y %H:%M ")
seperator = widget({ type = "textbox" })
seperator.text = " | "
spacer = widget({ type = "textbox" })
spacer.width = 6



-- Create a systray
mysystray = widget({ type = "systray" })


-- Icons and Widgets
cpuicon = widget ({ type = "textbox" })
cpuicon.bg_image = image("/usr/share/awesome/themes/icons/zenburn/cpu.png")
cpuicon.bg_align = "middle"
cpuicon.width = 8
-- netdownicon = widget ({ type = "textbox" })
-- netdownicon.bg_image = image("/usr/share/awesome/themes/icons/zenburn/down.png")
-- netdownicon.bg_align = "middle"
-- netdownicon.width = 8
-- netupicon = widget ({ type = "textbox" })
-- netupicon.bg_image = image("/usr/share/awesome/themes/icons/zenburn/up.png")
-- netupicon.bg_align = "middle"
-- netupicon.width = 8
batticon = widget ({ type = "textbox" })
batticon.bg_image = image("/usr/share/awesome/themes/icons/zenburn/bat.png")
batticon.bg_align = "middle"
batticon.width = 8
tempicon = widget ({ type = "textbox" })
tempicon.bg_image = image("/usr/share/awesome/themes/icons/zenburn/temp.png")
tempicon.bg_align = "middle"
tempicon.width = 8
volicon = widget ({ type = "textbox" })
volicon.bg_image = image("/usr/share/awesome/themes/icons/zenburn/vol.png")
volicon.bg_align = "middle"
volicon.width = 8
timeicon = widget ({ type = "textbox" })
timeicon.bg_image = image("/usr/share/awesome/themes/icons/zenburn/time.png")
timeicon.bg_align = "middle"
timeicon.width = 8

cpuinfo = widget ({ type = "textbox" })
-- netdowninfo = widget ({ type = "textbox" })
-- netupinfo = widget ({ type = "textbox" })
battinfo = widget ({ type = "textbox" })
tempinfo = widget ({ type = "textbox" })
volinfo = widget ({ type = "textbox" })
volbuttons = awful.util.table.join(
		awful.button({ }, 1, function() awful.util.spawn_with_shell("urxvt -name alsamixerfloat -e alsamixer", mouse.screen) end)
		)
volinfo:buttons(volbuttons)
timebuttons = awful.util.table.join(
		awful.button({ }, 1, function() awful.util.spawn("hamster-time-tracker", false, mouse.screen) end)
		)
timeicon:buttons(timebuttons)

vicious.register(cpuinfo, vicious.widgets.cpu, "$2% / $3% / $4% / $5%")
-- vicious.register(netdowninfo, vicious.widgets.net, "${wlan0 down_kb}", 3)
-- vicious.register(netupinfo, vicious.widgets.net, "${wlan0 up_kb}", 3)
vicious.register(battinfo, vicious.widgets.bat, "$2%$1", 60, "BAT0")
vicious.register(tempinfo, vicious.widgets.thermal, "$1°C", 5, "thermal_zone0")
vicious.register(volinfo, vicious.widgets.volume, "$2 $1%", 1, "Master")



-- Create a wibox for each screen and add it
mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, awful.tag.viewnext),
                    awful.button({ }, 5, awful.tag.viewprev)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt({ layout = awful.widget.layout.horizontal.leftright })
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.label.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(function(c)
                                              return awful.widget.tasklist.label.currenttags(c, s)
                                          end, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })
    -- Add widgets to the wibox - order matters
    mywibox[s].widgets = {
        {
            mylauncher,
            mytaglist[s],
            mypromptbox[s],
            layout = awful.widget.layout.horizontal.leftright
        },
        mylayoutbox[s],
        spacer, timeicon, seperator, mytextclock,
        s == 1 and mysystray or nil,
	seperator, volinfo,
	seperator, tempinfo, spacer, tempicon,
	seperator, cpuinfo, spacer, cpuicon, seperator,
	battinfo, spacer, batticon, seperator,
	mytasklist[s],
        layout = awful.widget.layout.horizontal.rightleft
    }
end
