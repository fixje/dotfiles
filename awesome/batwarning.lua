---------------------------------------------------------
-- Battery warning module to include in awesome's rc.lua
-- depends on vicious and may be ugly, but it works ;)
-- written by Markus Fuchs 2012 <mail@mfuchs.org>
-- Licensed under the GNU General Public License v2
-- known issues: complains when battery is charging
---------------------------------------------------------

local helpers = require("vicious.helpers")

-- store levels we have warned for
batt_already_warned = 0
-- text widget for battery
battinfo_text = widget({ type = "textbox" })
battinfo_text.align = "right"
battinfo_text.text = ""

shutdown_timer = nil
shutdown_time = 120
local function countdown_shutdown()
	shutdown_time = shutdown_time - 1
	battinfo_text.text = "Shutting down in "..shutdown_time.."s"
	if shutdown_time == 0 then
		awful.util.spawn_with_shell("sudo init 0", 1)
		shutdown_time = 0
	end
end

local function get_bat_percentage()
	local battery =  helpers.pathtotable("/sys/class/power_supply/BAT0")

	-- Get capacity information
	if battery.charge_now then
	    remaining, capacity = battery.charge_now, battery.charge_full
	elseif battery.energy_now then
	    remaining, capacity = battery.energy_now, battery.energy_full
	else
	    return 0
	end
	-- Calculate percentage (but work around broken BAT/ACPI implementations)
	local percent = math.min(math.floor(remaining / capacity * 100), 100)
	return percent
end

local function create_bottom_bar()
	local bottom_bar = {}
	for s = 1, screen.count() do
	    -- Create the wibox
	    bottom_bar[s] = awful.wibox({ position = "bottom", screen = s })
	    -- Add widgets to the wibox - order matters
	    bottom_bar[s].widgets = {
		battinfo_text,
		layout = awful.widget.layout.horizontal.rightleft
	    }
    end
end

local function bat_warning()
	local p = get_bat_percentage()
	if p == 0 then
		return
	end
	if p < 20 and p > 9 and batt_already_warned < 1 then
		batt_already_warned = 1
		for s = 1, screen.count() do
			naughty.notify({preset = naughty.config.presets.low, 
				title = "Battery Warning", 
				text = "Battery level low.", 
				icon = "/usr/share/awesome/themes/icons/batterymon/battery_2.png", 
				timeout = 7,
				screen = s})
		end
	elseif p < 10 and p > 4 then
		batt_already_warned = 2
		for s = 1, screen.count() do
			naughty.notify({preset = naughty.config.presets.normal,
				title = "Battery Warning",
				text = "Battery level very low!",
				icon = "/usr/share/awesome/themes/icons/batterymon/battery_1.png",
				timeout = 15,
				screen = s})
			end
	elseif p < 5 then
		batt_already_warned = 3
		if shutdown_timer == nil then
			create_bottom_bar()
			shutdown_timer = timer({timeout = 1})
			shutdown_timer:add_signal("timeout", countdown_shutdown)
			shutdown_timer:start()
		end
		for s = 1, screen.count() do
			naughty.notify({preset = naughty.config.presets.critical,
				title = "Battery Warning",
				text = "Battery level CRITICAL! Shutdown in 2 minutes.",
				icon = "/usr/share/awesome/themes/icons/batterymon/battery_empty.png",
				timeout = 0,
				screen = s})
		end
	end
end

battimer = timer({timeout = 120})
battimer:add_signal("timeout", bat_warning)
battimer:start()


