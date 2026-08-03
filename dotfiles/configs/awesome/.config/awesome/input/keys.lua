pcall(require, "luarocks.loader")

-- Standard awesome library
local gears = require("gears")
local awful = require("awful")

-- Notification library
local naughty = require("naughty")

local hotkeys_popup = require("awful.hotkeys_popup")
local spotify_shell = require("awesome-wm-widgets.spotify-shell.spotify-shell")

local function open_spotify_shell()
	Notify("opening spotify")
	spotify_shell.launch()
end

local function open_spotify()
	awful.util.spawn("spotify-launcher --skip-update")
end

local function take_screenshot()
	awful.util.spawn("scrot " .. Home .. "/screenshots/%Y-%m-%d--%H-%M-%S.png")
	naughty.notify({ text = "Taking a screenshot" })
end
local function take_selected_screenshot()
	awful.util.spawn("scrot -s -d 1  " .. Home .. "/screenshots/%Y-%m-%d--%H-%M-%S.png")
	naughty.notify({ text = "Saving snippet" })
end

local globalkeys = gears.table.join(

	-- basic help
	awful.key({ Modkey }, "a", hotkeys_popup.show_help, { description = "show help", group = "awesome" }),
	awful.key({ Modkey, "Control" }, "r", awesome.restart, {
		description = "reload awesome",
		group = "awesome",
	}),
	awful.key({ Modkey, "Control" }, "q", awesome.quit, {
		description = "quit awesome",
		group = "awesome",
	}),

	-- Standard program

	awful.key({ Modkey }, "Return", function()
		awful.spawn(Terminal)
	end, { description = "open a Terminal", group = "launcher" }),

	awful.key({ Modkey }, "g", function()
		awful.util.spawn("google-chrome-stable")
	end, { description = "web browser", group = "applications" }),

	awful.key({ Modkey }, "y", function()
		awful.util.spawn("google-chrome-stable youtube.com")
	end, { description = "web browser", group = "applications" }),

	-- screenshot
	awful.key({ Modkey, "Shift" }, "0", take_screenshot, {
		description = "take a screenshot",
		group = "screenshot",
	}),
	awful.key({ Modkey, "Control" }, "0", take_selected_screenshot, {
		description = "take selected screenshot",
		group = "screenshot",
	}),

	-- spotify controls
	awful.key({ Modkey }, "l", open_spotify, {
		description = "open spotify",
		group = "music",
	}),
	awful.key({ Modkey }, "d", open_spotify_shell, {
		description = "open spotify shell",
		group = "music",
	}),
	awful.key({ Modkey }, "0", function()
		local screen = awful.screen.focused()
		local tag = screen.tags[10]
		if tag then
			tag:view_only()
		end
	end, { description = "take a screenshot", group = "screenshot" }),
	awful.key({ Modkey }, "/", function()
		awful.util.spawn("sp play", false)
	end),
	awful.key({ Modkey }, ".", function()
		awful.util.spawn("sp next", false)
	end),
	awful.key({ Modkey }, ",", function()
		awful.util.spawn("sp prev", false)
	end),

	-- change background
	awful.key({ Modkey }, "=", function()
		awful.spawn.with_shell("feh --bg-fill --random ~/wallpapers")
	end, {
		description = "Change Wallpaper",
		group = "awesome",
	}),

	-- client manipulation

	-- by index
	awful.key({ Modkey }, "j", function()
		awful.client.focus.byidx(1)
	end, { description = "focur next client", group = "client" }),
	awful.key({ Modkey }, "k", function()
		awful.client.focus.byidx(-1)
	end, { description = "focur previous client", group = "client" }),

	-- by direction
	awful.key({ Modkey }, "h", function()
		awful.client.focus.bydirection("left")
	end, { description = "focur left client", group = "client" }),
	awful.key({ Modkey }, "l", function()
		awful.client.focus.bydirection("right")
	end, { description = "focur right client", group = "client" }),

	-- Layout manipulation (height & width)
	awful.key({ Modkey, "Shift" }, "l", function()
		awful.tag.incmwfact(0.05)
	end, { description = "increase master width factor", group = "layout" }),
	awful.key({ Modkey, "Shift" }, "h", function()
		awful.tag.incmwfact(-0.05)
	end, { description = "decrease master width factor", group = "layout" }),
	awful.key({ Modkey, "Shift" }, "o", function()
		awful.client.incwfact(0.05)
	end, { description = "let's see", group = "client" }),
	awful.key({ Modkey, "Shift" }, ";", function()
		awful.client.incwfact(-0.05)
	end, { description = "let's see", group = "client" }),
	-- Layout manipulation (tile shifting)
	awful.key({ Modkey, "Shift" }, "j", function()
		awful.client.swap.byidx(1)
	end, { description = "swap with next client by index", group = "client" }),
	awful.key({ Modkey, "Shift" }, "k", function()
		awful.client.swap.byidx(-1)
	end, { description = "swap with previous client by index", group = "client" }),
	awful.key({ Modkey }, "o", function()
		awful.screen.focus_relative(1)
	end, { description = "focus the next screen", group = "screen" }),
	--awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
	--        {description = "focus the previous screen", group = "screen"}),
	--awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
	--        {description = "jump to urgent client", group = "client"}),

	-- layouts
	awful.key({ Modkey, "Shift" }, "Right", function()
		awful.layout.inc(1)
	end, { description = "select next", group = "layout" }),
	awful.key({ Modkey, "Shift" }, "Left", function()
		awful.layout.inc(-1)
	end, { description = "select previous", group = "layout" }),

	awful.key({ Modkey, "Control" }, "o", function()
		local c = awful.client.restore()
		-- Focus restored client
		if c then
			c:emit_signal("request::activate", "key.unminimize", { raise = true })
		end
	end, { description = "restore minimized", group = "client" }),
	awful.key({ Modkey }, "Tab", awful.tag.history.restore, { description = "go back", group = "tag" }),
	-- awful.key({ Modkey }, "Tab", function()
	-- 	awful.client.focus.history.previous()
	-- 	if client.focus then
	-- 		client.focus:raise()
	-- 	end
	-- end, { description = "go back", group = "client" }),

	-- volume controls
	awful.key({ Modkey }, "[", function()
		-- awful.spawn.with_shell("pactl -- set-sink-volume 0 +5%")
		awesome.emit_signal("acpi::volume_up")
	end, { description = "Increse volume", group = "Volume" }),
	awful.key({ Modkey }, "]", function()
		-- awful.spawn.with_shell("pactl -- set-sink-volume 0 -5%")
		awesome.emit_signal("acpi::volume_down")
	end, { description = "Decrease volume", group = "Volume" }),
	awful.key({}, "XF86AudioMuteVolume", function()
		awesome.emit_signal("acpi::volume_mute")
	end, { description = "Mute volume", group = "Volume" }),

	-- topbar visibility
	awful.key({ Modkey }, "b", function()
		awful.screen.focused().mywibox.visible = not awful.screen.focused().mywibox.visible
	end, {
		description = "Toggle top-bar visibility",
		group = "custom",
	}),

	awful.key({ "Mod4" }, "space", function()
		awful.util.spawn("rofi -show run")
	end, { description = "run prompt", group = "launcher" })

	-- awful.key({ modkey }, "z", function()
	-- 	local next_obj = {}
	-- 	for k, v in pairs(object) do
	-- 		next_obj[k] = v + math.random(100)
	-- 		object[k] = next_obj[k]
	-- 	end
	-- 	new_anim.target(next_obj)
	-- end, { description = "testing", group = "awesome" }),
)

return globalkeys
