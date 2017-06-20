-- Standard awesome library
awful = require("awful")
require("awful.autofocus")
-- Theme handling library
require("beautiful")
-- Notification library
require("naughty")


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
                         text = err })
        in_error = false
    end)
end
-- }}}

-- global vars, layouts, theme
require("global")

-- menu (incl. freedesktop)
require("menu")

-- top wibox incl. widgets
require("top-bar")

-- mouse and key bindings
require("keys")

-- special window rules
require("rules")

-- hooks and signals
require("signals")

-- battery warning
-- KDE require("batwarning")

-- HACK to fix Java GUIs
awful.util.spawn_with_shell("wmname LG3D")
