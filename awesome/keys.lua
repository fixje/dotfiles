mousefinder = awful.mouse.finder()

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "s",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
	--    awful.key({ modkey,           }, "w", function () mymainmenu:show({keygrabber=true}) end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "s", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "w", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "s",
	function () 
		awful.screen.focus_relative( 1)
		-- BUG: mouse finder animation does not appear on right spot mousefinder:find()
	end),
    awful.key({ modkey, "Control" }, "w",
	function () 
		awful.screen.focus_relative(-1)
		-- BUG: mouse finder animation does not appear on right spot mousefinder:find()
	end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "t", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "d",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "a",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "a",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "d",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "a",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "d",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore()),
    awful.key({ modkey }, "q", function () mousefinder:find() end),

    -- Prompt
    awful.key({ modkey }, "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),

    -- custom hotkeys
    awful.key({},            "XF86ModeLock",   function () awful.util.spawn_with_shell("xlock -mode blank -bg black -fg green") end),
    awful.key({},            "XF86Standby",   function () awful.util.spawn_with_shell("xset dpms force off") end),
    awful.key({},            "XF86Launch1",   function () awful.util.spawn_with_shell("urxvt") end),
    awful.key({},            "XF86SplitScreen", function () awful.util.spawn_with_shell("lxrandr") end),
    awful.key({}, "XF86Launch4", function () awful.util.spawn("sudo /usr/local/bin/bluetooth-toggle.sh") 
end),
    awful.key({}, "XF86Launch5", function () awful.util.spawn("/usr/local/bin/touchpad-toggle.sh") end),
    awful.key({ }, "XF86AudioLowerVolume", function () 
                        awful.util.spawn("amixer -q sset Master 2dB-") 
                        local f = io.popen("amixer get Master | egrep \"Front Left: Playback\" | egrep -o \"[0-9]+%\"")
			local fr = ""
			for line in f:lines() do
				fr = fr .. line .. "\n"
			end
			f:close()
			-- naughty.notify({ text = "Master Volume: " .. fr .. "", timeout = 1})
    end),
    awful.key({ }, "XF86AudioRaiseVolume", function () 
                        awful.util.spawn("amixer -q sset Master 2dB+") 
                        local f = io.popen("amixer get Master | egrep \"Front Left: Playback\" | egrep -o \"[0-9]+%\"")
			local fr = ""
			for line in f:lines() do
				fr = fr .. line .. "\n"
			end
			f:close()
			-- naughty.notify({ text = "Master Volume: " .. fr .. "", timeout = 1})
    end),
    awful.key({ }, "XF86AudioMute", function () 
                        awful.util.spawn("amixer set Master toggle") 
                        local f = io.popen("amixer get Master | egrep \"Front Left: Playback\" | cut -d \" \" -f 9")
			local fr = ""
			for line in f:lines() do
				fr = fr .. line .. "\n"
			end
			f:close()
			-- naughty.notify({ text = "Toggled Sound: " .. fr .. "", timeout = 1})
    end),
    awful.key({modkey}, "e", revelation)
)

-- generate and add the 'run or raise' key bindings to the globalkeys table
globalkeys = awful.util.table.join(globalkeys, aweror.genkeys(modkey))

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Control" }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey, "Shift"   }, "r",      function (c) c:redraw()                       end),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Compute the maximum number of digit we need, limited to 9
keynumber = 0
for s = 1, screen.count() do
   keynumber = math.min(9, math.max(#tags[s], keynumber));
end

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        if tags[screen][i] then
                            awful.tag.viewonly(tags[screen][i])
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      if tags[screen][i] then
                          awful.tag.viewtoggle(tags[screen][i])
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.movetotag(tags[client.focus.screen][i])
                      end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus and tags[client.focus.screen][i] then
                          awful.client.toggletag(tags[client.focus.screen][i])
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}
