local awful = require("awful")
local gears = require("gears")
local wibox = require("wibox")

local tasklist_buttons = require("screen.tasks.mouse")

local function setup(screen)
	-- Create a tasklist widget
	screen.mytasklist = awful.widget.tasklist({
		screen = screen,
		filter = awful.widget.tasklist.filter.currenttags,
		buttons = tasklist_buttons,
		style = {
			align = "center",
		},
		layout = {
			spacing_widget = {
				{
					widget = wibox.widget.separator,
				},
				valign = "center",
				halign = "center",
				widget = wibox.container.place,
			},
			layout = wibox.layout.fixed.horizontal,
		},
		widget_template = {
			{
				{
					{
						id = "icon_role",
						widget = wibox.widget.imagebox,
					},
					{
						{
							id = "text_role",
							widget = wibox.widget.textbox,
							-- ellipsize = "start",
						},
						strategy = "max",
						width = 200,
						widget = wibox.container.constraint,
					},
					spacing = 8,
					layout = wibox.layout.fixed.horizontal,
				},
				left = 10,
				right = 10,
				widget = wibox.container.margin,
			},
			shape = gears.shape.rounded_rect,
			widget = wibox.container.background,
		},
	})
end
return setup
