pcall(require, "luarocks.loader")
-- local rubato = require("rubato")

-- Standard awesome library
local awful = require("awful")
require("awful.autofocus")
local launcher = require("ui.topbar.launcher")
local text_clock = require("ui.widgets.clock")

-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
-- local naughty = require("naughty")

local dpi = require("beautiful.xresources").apply_dpi

local space_widget = wibox.widget({
	forced_width = 5,
	layout = wibox.layout.fixed.horizontal,
})

--local menubar = require("menubar")

-- Table of layouts to cover with awful.layout.inc, order matters.
-- awful.layout.layouts = {
-- 	awful.layout.suit.tile,
-- 	awful.layout.suit.floating,
-- 	awful.layout.suit.tile.left,
-- 	awful.layout.suit.tile.bottom,
-- 	awful.layout.suit.tile.top,
-- 	awful.layout.suit.fair,
-- 	awful.layout.suit.fair.horizontal,
-- 	awful.layout.suit.spiral,
-- 	awful.layout.suit.spiral.dwindle,
-- 	awful.layout.suit.max,
-- 	awful.layout.suit.max.fullscreen,
-- 	awful.layout.suit.magnifier,
-- 	awful.layout.suit.corner.nw,
-- 	awful.layout.suit.corner.ne,
-- 	awful.layout.suit.corner.sw,
-- 	awful.layout.suit.corner.se,
-- }

local brightness_widget = require("awesome-wm-widgets.brightness-widget.brightness")
local battery_widget = require("awesome-wm-widgets.battery-widget.battery")
local spotify_widget = require("awesome-wm-widgets.spotify-widget.spotify")
-- local player_widget = require("awesome-wm-widgets.player-controller.player")
-- local spotify_shell = require("awesome-wm-widgets.spotify-shell.spotify-shell")
local volume_widget = require("awesome-wm-widgets.volume-widget.volume")
--local todo_widget = require("awesome-wm-widgets.todo-widget.todo")
-- local wifi_widget = require("code.awesome-widgets.wifi_util")
-- local batteryarc_widget = require("awesome-wm-widgets.batteryarc-widget.batteryarc")

local function setup(screen)
	-- Create the wibox

	screen.mywibox = awful.wibar({
		position = "top",
		height = 46,
		width = screen.geometry.width,
		screen = screen,
		fg = beautiful.fg_normal,
		opacity = 0.75, -- set the opacity to make it transparent
		visible = true,
		-- ontop = true,
		widget = wibox.container.background,
	})

	screen.mywibox:setup({
		{
			layout = wibox.layout.align.horizontal,
			-- expand = "outside",
			{ -- Left widgets
				layout = wibox.layout.fixed.horizontal,
				launcher,
				space_widget,
				screen.mytaglist,
				-- s.mypromptbox,
			},
			screen.mytasklist, -- Middle widget
			{ -- Right widgets
				layout = wibox.layout.fixed.horizontal,
				-- player_widget({
				-- 	play_icon = HOME .. "wallpapers/spotify_green.svg",
				-- 	pause_icon = HOME .. "wallpapers/spotify_green.svg",
				-- 	font = "Fira Code " .. dpi(13),
				-- 	dim_when_paused = true,
				-- 	dim_opacity = 0.5,
				-- 	max_length = 10,
				-- 	show_tooltip = true,
				-- }),
				-- cpu_widget({
				--     width = 50,
				--     step_width = 2,
				--     step_spacing = 0,
				--     color = '#434c5e'
				-- }),
				-- ram_widget({
				--     color_used=beautiful.bg_urgent,
				--     color_free =beautiful.fg_normal,
				--     color_buf='orange',
				--     widget_height=25,
				--     widget_width=25,
				--     widget_show_buf= true,
				-- }),
				spotify_widget({
					play_icon = Home .. "wallpapers/spotify_green.svg",
					pause_icon = Home .. "wallpapers/spotify_green.svg",
					font = "Fira Code " .. dpi(13),
					dim_when_paused = true,
					dim_opacity = 0.5,
					max_length = 250,
					show_tooltip = true,
				}),
				space_widget,
				wibox.widget.systray(),
				space_widget,
				brightness_widget({
					type = "arc",
					program = "brightnessctl",
					base = 50,
					step = 5,
					size = 22,
					arc_thickness = 2.2,
				}),
				space_widget,
				volume_widget({
					device = "default",
					mixctrl = "Master",
					widget_type = "arc",
					size = 22,
					thickness = 2.2,
					valueType = "",
					card = 0,
				}),
				space_widget,
				battery_widget({
					show_current_level = true,
					font = "Fira Code Bold" .. dpi(14),
				}),
				space_widget,
				-- wifi_widget({
				--     mode = 'wifi'
				-- }),
				-- space_widget,
				text_clock,
			},
		},
		margins = 6, -- padding on all sides
		widget = wibox.container.margin,
	})
end

return setup
