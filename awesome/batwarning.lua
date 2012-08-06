---------------------------------------------------------
-- Battery warning module to include in awesome's rc.lua
-- depends on vicious and may be ugly, but it works ;)
-- written by Markus Fuchs 2012 <mail@mfuchs.org>
-- Licensed under the GNU General Public License v2
---------------------------------------------------------

local helpers = require("vicious.helpers")

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

local function bat_warning()
	local p = get_bat_percentage()
	if p == 0 then
		return
	end
	if p < 20 then
		for s = 1, screen.count() do
			naughty.notify({preset = naughty.config.presets.low, 
				title = "Battery Warning", 
				text = "Battery level low.", 
				icon = "/usr/share/awesome/themes/icons/batterymon/battery_2.png", 
				timeout = 7,
				screen = s})
		end
	elseif p < 10 then
		for s = 1, screen.count() do
			naughty.notify({preset = naughty.config.presets.normal,
				title = "Battery Warning",
				text = "Battery level very low!",
				icon = "/usr/share/awesome/themes/icons/batterymon/battery_1.png",
				timeout = 15,
				screen = s})
			end
	elseif p < 5 then
		for s = 1, screen.count() do
			naughty.notify({preset = naughty.config.presets.critical,
				title = "Battery Warning",
				text = "Battery level CRITICAL!",
				icon = "/usr/share/awesome/themes/icons/batterymon/battery_empty.png",
				timeout = 0,
				screen = s})
		end
	end
end

battimer = timer({timeout = 120})

battimer:add_signal("timeout", bat_warning)
battimer:start()
