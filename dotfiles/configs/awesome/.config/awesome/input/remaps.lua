local awful = require("awful")
local gears = require("gears")

local remaps = gears.table.join(
	awful.key({}, "XF86MonBrightnessDown", function()
		awesome.emit_signal("acpi::brightness_down")
	end),
	awful.key({}, "XF86MonBrightnessUp", function()
		awesome.emit_signal("acpi::brightness_up")
	end)
)

return remaps
