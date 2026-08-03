local naughty = require("naughty")
local awful = require("awful")

local ICON_PATH = "/usr/share/icons/Adwaita/scalable/mimetypes/audio-x-generic.svg"
local ICON_SIZE = nil
local EVENT_TIMEOUT = 1
local EVENT = "VOLUME"
local notification_id = nil

local function notify(e_type, e_msg)
	if naughty.getById(notification_id) then
		local notification = naughty.notify({
			replaces_id = notification_id,
			icon = ICON_PATH,
			-- title = e_type,
			text = e_msg,
			timeout = 8,
		})
		notification_id = notification.id
		naughty.reset_timeout(notification, 8)
	end
	local notification = naughty.notify({
		replaces_id = notification_id,
		icon = ICON_PATH,
		-- title = e_type,
		text = e_msg,
		timeout = EVENT_TIMEOUT,
	})
	notification_id = notification.id
end

local function get_volume(callback)
	awful.spawn.easy_async_with_shell(
		"pactl get-sink-volume @DEFAULT_SINK@ | awk '{print $5}' | head -n1",
		function(stdout)
			callback(stdout:gsub("\n", ""))
		end
	)
end

local function is_muted(callback)
	awful.spawn.easy_async_with_shell("pactl get-sink-mute @DEFAULT_SINK@ | awk '{print $2}'", function(stdout)
		callback(stdout:gsub("\n", ""))
	end)
end

awesome.connect_signal("acpi::volume_up", function()
	-- Unmute as well
	awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ 0", false)
	awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ +5%", false)

	get_volume(function(vol)
		notify(EVENT, string.format("Volume %s", vol))
	end)
end)

awesome.connect_signal("acpi::volume_down", function()
	awful.spawn("pactl set-sink-volume @DEFAULT_SINK@ -5%", false)

	get_volume(function(vol)
		notify(EVENT, string.format("Volume %s", vol))
	end)
end)

awesome.connect_signal("acpi::volume_mute", function()
	awful.spawn("pactl set-sink-mute @DEFAULT_SINK@ toggle", false)

	is_muted(function(state)
		local msg = (state == "yes") and "Muted" or "Unmuted"
		notify(EVENT, msg)
	end)
end)
