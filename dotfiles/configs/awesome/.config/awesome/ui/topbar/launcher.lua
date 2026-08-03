local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local mylauncher = wibox.widget({
	{
		markup = "󰣇", -- icon (or use an image widget)
		font = "JetBrainsMono Nerd Font 18",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	},
	bg = "#2E3440",
	fg = "#ECEFF4",
	shape = gears.shape.rounded_rect,
	forced_width = 40,
	forced_height = 40,
	widget = wibox.container.background,
})

mylauncher:buttons(gears.table.join(awful.button({}, 1, function()
	awful.spawn("rofi -show drun")
end)))

return mylauncher
