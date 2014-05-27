local vicious = require("vicious")
local awful = require("awful")
local wibox = require("wibox")

icons = awful.util.getdir("config") .. "/themes/icons"

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock(" %d.%m.%Y %H:%M ")
seperator = wibox.widget.textbox()
seperator:set_text(" | ")
spacer = wibox.widget.textbox()
spacer.width = 6

-- Icons and Widgets
cpuicon = wibox.widget.imagebox()
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

cpuinfo = wibox.widget.textbox()
cpuinfo:set_align("right")
battinfo = wibox.widget.textbox()
tempinfo = wibox.widget.textbox()

volinfo = wibox.widget.textbox()
volbuttons = awful.util.table.join(
        awful.button({ }, 1, function() awful.util.spawn_with_shell("urxvt -name alsamixerfloat -e alsamixer", mouse.screen) end)
        )
volinfo:buttons(volbuttons)

timebuttons = awful.util.table.join(
        awful.button({ }, 1, function() awful.util.spawn("hamster-time-tracker", false, mouse.screen) end)
        )
timeicon:buttons(timebuttons)

pulseicon:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.util.spawn("pavucontrol", false,  mouse.screen) end)
))

vicious.register(cpuinfo, vicious.widgets.cpu, "$2% / $3% / $4% / $5%")
--cpuinfo = wibox.layout.constraint(cpuinfo, "exact", 135, nil)
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
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
)
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
    awful.button({ }, 1, function (c)
                if c == client.focus then
            c.minimized = true
                else
            -- Without this, the following
            -- :isvisible() makes no sense
            c.minimized = false
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
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(cpuicon)
    right_layout:add(cpuinfo)
    right_layout:add(seperator)
    right_layout:add(batticon)
    right_layout:add(battinfo)
    right_layout:add(seperator)
    right_layout:add(tempicon)
    right_layout:add(tempinfo)
    right_layout:add(seperator)
    right_layout:add(volinfo)
    right_layout:add(pulseicon)
    right_layout:add(seperator)    
    --right_layout:add(timeicon)
    right_layout:add(mytextclock)

    right_layout:add(mylayoutbox[s])

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
