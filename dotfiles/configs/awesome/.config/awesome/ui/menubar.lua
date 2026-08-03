local awful = require("awful")
local gears = require("gears")
local beautiful = require("beautiful")

local myapps = {
	{
		"Firefox",
		function()
			awful.util.spawn("firefox")
		end,
	},
	{
		"Chrome",
		function()
			awful.util.spawn("google-chrome-stable")
		end,
	},
	{
		"Tekken",
		function()
			awful.util.spawn("wine " .. Home .. "/games/Tekken_3.exe")
		end,
	},
	{
		"lutris",
		function()
			awful.util.spawn("lutris")
		end,
	},
	{
		"VLC",
		function()
			awful.util.spawn("vlc")
		end,
	},
	{
		"wallpaper",
		function()
			awful.util.spawn("nitrogen")
		end,
	},
	{
		"Spotify",
		function()
			awful.util.spawn("spotify-launcher --skip-update")
		end,
	},
	-- Basic layout for adding option in apps
	--{ "", function() awful.util.spawn("") end},
}

local myawesomemenu = {
	{
		"Hotkeys",
		function()
			local hotkeys_popup = require("awful.hotkeys_popup")
			hotkeys_popup.show_help(nil, awful.screen.focused())
		end,
	},
	{ "Manual", Terminal .. " -e man awesome" },
	{ "Edit config", Editor_cmd .. " " .. awesome.conffile },
	{ "Restart", awesome.restart },
	{
		"Quit",
		function()
			awesome.quit()
		end,
	},
}

beautiful.menu_height = 20
beautiful.menu_width = 150
--beautiful.menu_fg_normal=""
--beautiful.menu_fg_focus="#4c4b49"
--beautiful.menu_bg_normal="#2b3339"
--beautiful.menu_bg_focus="#1e2327"
-- To add awesome icon add ", beautiful.awesome_icon" after myawesomemenu or myapps

local mymainmenu = awful.menu({
	items = { { "apps", myapps }, { "awesome", myawesomemenu }, { "terminal", Terminal } },
})

-- local launcher = awful.widget.launcher({
-- 	image = Home .. "/downloads/images/message.png",
-- 	menu = mymainmenu,
-- })

root.buttons(gears.table.join(awful.button({}, 3, function()
	mymainmenu:toggle()
end)))
