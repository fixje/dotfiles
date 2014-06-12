-------------------------------------------------------------------
-- Drop-down applications manager for the awesome window manager
-------------------------------------------------------------------
-- Coded  by: * Lucas de Vries <lucas@glacicle.com>
-- Hacked by: * Adrian C. (anrxc) <anrxc@sysphere.org>
--            * Markus Fuchs <web-code@mfuchs.org>
-- Licensed under the WTFPL version 2
--   * http://sam.zoy.org/wtfpl/COPYING
-------------------------------------------------------------------
-- To use this module add:
--   local scratchdrop = require("scratchdrop")
-- to the top of your rc.lua, and call it from a keybinding:
--   scratchdrop(prog, vert, horiz, width, height, sticky, screen)
--
-- Parameters:
--   prog   - Program to run; "urxvt", "gmrun", "thunderbird"
--   vert   - Vertical; "bottom", "center" or "top" (default)
--   horiz  - Horizontal; "left", "right" or "center" (default)
--   width  - Width in absolute pixels, or width percentage
--            when <= 1 (1 (100% of the screen) by default)
--   height - Height in absolute pixels, or height percentage
--            when <= 1 (0.25 (25% of the screen) by default)
--   sticky - Visible on all tags, false by default
--   screen - Screen (optional), mouse.screen by default
-------------------------------------------------------------------

-- Grab environment
local pairs = pairs
local awful = require("awful")
local setmetatable = setmetatable
local capi = {
    mouse = mouse,
    client = client,
    screen = screen
}

-- Determine signal usage in this version of awesome
local attach_signal = capi.client.connect_signal    or capi.client.add_signal
local detach_signal = capi.client.disconnect_signal or capi.client.remove_signal

-- Scratchdrop: drop-down applications manager for the awesome window manager
local scratchdrop = {} -- module scratch.drop

local dropdown = {}

-- register X11 property for scratchtop clients
awesome.register_xproperty("AWESOME_SCRATCHDROP_VERT", "string")
awesome.register_xproperty("AWESOME_SCRATCHDROP_HORIZ", "string")
awesome.register_xproperty("AWESOME_SCRATCHDROP_WIDTH", "string")
awesome.register_xproperty("AWESOME_SCRATCHDROP_HEIGHT", "string")
awesome.register_xproperty("AWESOME_SCRATCHDROP_STICKY", "boolean")
awesome.register_xproperty("AWESOME_SCRATCHDROP_SCREEN", "string")
awesome.register_xproperty("AWESOME_SCRATCHDROP_PROG", "string")


function set_scratchdrop_properties(c, vert, horiz, width, height, sticky, screen, prog)
    -- Scratchdrop clients are floaters
    awful.client.floating.set(c, true)

    -- Client geometry and placement
    local screengeom = capi.screen[screen].workarea

    -- store values
    c:set_xproperty("AWESOME_SCRATCHDROP_VERT", vert)
    c:set_xproperty("AWESOME_SCRATCHDROP_HORIZ", horiz)
    c:set_xproperty("AWESOME_SCRATCHDROP_WIDTH", width)
    c:set_xproperty("AWESOME_SCRATCHDROP_HEIGHT", height)
    c:set_xproperty("AWESOME_SCRATCHDROP_STICKY", sticky)
    c:set_xproperty("AWESOME_SCRATCHDROP_SCREEN", screen)
    c:set_xproperty("AWESOME_SCRATCHDROP_PROG", prog)

    if width  <= 1 then width  = (screengeom.width  * width) - 3 end
    if height <= 1 then height = screengeom.height * height end

    if     horiz == "left"  then x = screengeom.x
    elseif horiz == "right" then x = screengeom.width - width
    else   x =  screengeom.x+(screengeom.width-width)/2 - 1 end

    if     vert == "bottom" then y = screengeom.height + screengeom.y - height
    elseif vert == "center" then y = screengeom.y+(screengeom.height-height)/2
    else   y =  screengeom.y end

    -- Client properties
    c:geometry({ x = x, y = y, width = width, height = height })
    c.ontop = true
    c.above = true
    c.skip_taskbar = true
    if sticky then c.sticky = true end
    if c.titlebar then awful.titlebar.remove(c) end
end

-- Hide and detach tags if not
function scratchdrop_hide(c)
    c.hidden = true
    local ctags = c:tags()
    for i, t in pairs(ctags) do
        ctags[i] = nil
    end
    c:tags(ctags)
end


function scratchdrop_init_prog(prog)
    if not dropdown[prog] then
        dropdown[prog] = {}

        -- Add unmanage signal for scratchdrop programs
        attach_signal("unmanage", function (c)
            for scr, cl in pairs(dropdown[prog]) do
                if cl == c then
                    dropdown[prog][scr] = nil
                end
            end
        end)
    end
end


-- Create a new window for the drop-down application when it doesn't
-- exist, or toggle between hidden and visible states when it does
function toggle(prog, vert, horiz, width, height, sticky, screen)
    vert   = vert   or "top"
    horiz  = horiz  or "center"
    width  = width  or 1
    height = height or 0.25
    sticky = sticky or false
    screen = screen or capi.mouse.screen

    scratchdrop_init_prog(prog)

    if not dropdown[prog][screen] then
        spawnw = function (c)
            dropdown[prog][screen] = c

            set_scratchdrop_properties(c, vert, horiz, width, height, sticky, screen, prog)

            c:raise()
            capi.client.focus = c
            detach_signal("manage", spawnw)
        end

        -- Add manage signal and spawn the program
        attach_signal("manage", spawnw)
        awful.util.spawn_with_shell(prog, false) -- original without '_with_shell'
    else
        -- Get a running client
        c = dropdown[prog][screen]

        -- Switch the client to the current workspace
        if c:isvisible() == false then c.hidden = true
            awful.client.movetotag(awful.tag.selected(screen), c)
        end

        -- Focus and raise if hidden
        if c.hidden then
            -- Make sure it is centered
            if vert  == "center" then awful.placement.center_vertical(c)   end
            if horiz == "center" then awful.placement.center_horizontal(c) end
            c.hidden = false
            c:raise()
            capi.client.focus = c
        else
            scratchdrop_hide(c)
        end
    end
end


-- restore scratchtopped windows after restart if any
function scratchdrop_restore(c)
    if c:get_xproperty("AWESOME_SCRATCHDROP_VERT") ~= "" then
        local vert   = c:get_xproperty("AWESOME_SCRATCHDROP_VERT")
        local horiz  = c:get_xproperty("AWESOME_SCRATCHDROP_HORIZ")
        local width  = c:get_xproperty("AWESOME_SCRATCHDROP_WIDTH")
        local height = c:get_xproperty("AWESOME_SCRATCHDROP_HEIGHT")
        local sticky = c:get_xproperty("AWESOME_SCRATCHDROP_STICKY")
        local screen = c:get_xproperty("AWESOME_SCRATCHDROP_SCREEN")
        local prog = c:get_xproperty("AWESOME_SCRATCHDROP_PROG")
        width = tonumber(width)
        height = tonumber(height)
        screen = tonumber(screen)

        scratchdrop_init_prog(prog)
        set_scratchdrop_properties(c, vert, horiz, width, height, sticky, screen, prog)

        dropdown[prog][screen] = c

        scratchdrop_hide(c)
    end
end

attach_signal("manage", scratchdrop_restore)

return setmetatable(scratchdrop, { __call = function(_, ...) return toggle(...) end })
