require("freedesktop.utils")
require("freedesktop.menu")

freedesktop.utils.terminal = terminal  -- default: "xterm"
freedesktop.utils.icon_theme = 'oxygen' -- look inside /usr/share/icons/, default: nil (don't use icon theme)



-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome", freedesktop.utils.lookup_icon({ icon = 'help' }) },
   { "edit config", editor_cmd .. " " .. awesome.conffile, freedesktop.utils.lookup_icon({ icon = 'package_settings' })},
   { "restart", awesome.restart, freedesktop.utils.lookup_icon({ icon = 'gtk-refresh' }) },
   { "quit", awesome.quit, freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) }
}

menu_items = freedesktop.menu.new()
table.insert(menu_items, { "awesome", myawesomemenu, beautiful.awesome_icon })
table.insert(menu_items, { "open terminal", terminal, freedesktop.utils.lookup_icon({icon = 'terminal'}) })
table.insert(menu_items, { "Shutdown", "sudo systemctl poweroff", freedesktop.utils.lookup_icon({ icon = 'gtk-quit' }) })

mymainmenu = awful.menu.new({ items = menu_items, width = 200 })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
menu = mymainmenu })

