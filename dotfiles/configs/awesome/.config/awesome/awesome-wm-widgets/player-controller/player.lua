-- Usage:
--   playerctl [OPTION…] COMMAND - Controller for media players
--
--   For players supporting the MPRIS D-Bus specification
--
-- Help Options:
--   -h, --help                     Show help options
--
-- Application Options:
--      -p, --player=NAME              A comma separated list of names of players to control
--                                     (default: the first available player)
--      -a, --all-players              Select all available players to be controlled
--      -i, --ignore-player=IGNORE     A comma separated list of names of players to ignore.
--      -f, --format                   A format string for printing properties and metadata
--      -F, --follow                   Block and append the query to output when it changes
--                                     for the most recently updated player.
--      -l, --list-all                 List the names of running players that can be controlled
--      -s, --no-messages              Suppress diagnostic messages
--      -v, --version                  Print version information
--
-- Available Commands:
--      play                           Command the player to play
--      pause                          Command the player to pause
--      play-pause                     Command the player to toggle between play/pause
--      stop                           Command the player to stop
--      next                           Command the player to skip to the next track
--      previous                       Command the player to skip to the previous track
--      position [OFFSET][+/-]         Command the player to go to the position or seek forward/backward
--                                     OFFSET in seconds
--      volume [LEVEL][+/-]            Print or set the volume to LEVEL from 0.0 to 1.0
--      status                         Get the play status of the player
--      metadata [KEY...]              Print metadata information for the current track. If KEY is passed,
--                                     print only those values. KEY may be artist,title, album,
--                                     or any key found in the metadata.
--      open [URI]                     Command for the player to open given URI.
--                                     URI can be either file path or remote URL.
--      loop [STATUS]                  Print or set the loop status.
--                                     Can be "None", "Track", or "Playlist".
--      shuffle [STATUS]               Print or set the shuffle status.
--                                       Can be "On", "Off", or "Toggle".

local awful = require("awful")
local wibox = require("wibox")
local watch = require("awful.widget.watch")

local function ellipsize(text, length)
	-- utf8 only available in Lua 5.3+
	if utf8 == nil then
		return text:sub(0, length)
	end
	return (utf8.len(text) > length and length > 0) and text:sub(0, utf8.offset(text, length - 2) - 1) .. "..." or text
end

local player_widget = {}

local function worker(user_args)
	local args = user_args or {}

	local play_icon = args.play_icon or "/usr/share/icons/Arc/actions/24/player_play.png"
	local pause_icon = args.pause_icon or "/usr/share/icons/Arc/actions/24/player_pause.png"
	local font = args.font or "Play 9"
	local dim_when_paused = args.dim_when_paused == nil and false or args.dim_when_paused
	local dim_opacity = args.dim_opacity or 0.2
	local max_length = args.max_length or 15
	local show_tooltip = args.show_tooltip == nil and true or args.show_tooltip
	local timeout = args.timeout or 1
	local player = args.playerctl or "playerctl"

	local GET_PLAYER_STATUS_CMD = player .. " status"
	local GET_CURRENT_MEDIA_CMD = player .. " metadata title"
	local PLAY_CMD = player .. " play"
	local PAUSE_CMD = player .. " pause"
	local NEXT_MEDIA_CMD = player .. " next"
	local PREVIOUS_MEDIA_CMD = player .. " previous"

	local cur_title = ""
	local is_cur_playing = false

	player_widget = wibox.widget({
		{
			layout = wibox.layout.stack,
			{
				id = "icon",
				widget = wibox.widget.imagebox,
			},
			{
				widget = wibox.widget.textbox,
				font = font,
				text = " ",
				forced_height = 1,
			},
		},
		{
			max_size = max_length,
			-- layout = wibox.container.scroll.horizontal,
			layout = wibox.layout.stack,
			-- step_function = wibox.container.scroll.step_functions.waiting_nonlinear_back_and_forth,
			-- speed = 40,
			-- step_function = wibox.layout.stack({
			-- 	id = "titlew",
			-- 	font = font,
			-- 	widget = wibox.widget.textbox,
			-- }),
		},
		layout = wibox.layout.align.horizontal,
		set_status = function(self, is_playing)
			self:get_children_by_id("icon")[1]:set_image(is_playing and play_icon or pause_icon)
			if dim_when_paused then
				self:get_children_by_id("icon")[1]:set_opacity(is_playing and 1 or dim_opacity)

				self:get_children_by_id("titlew")[1]:set_opacity(is_playing and 1 or dim_opacity)
				self:get_children_by_id("titlew")[1]:emit_signal("widget::redraw_needed")
			end
		end,
		set_text = function(self, title)
			local title_to_display = ellipsize(title, max_length)
			if self:get_children_by_id("titlew")[1]:get_markup() ~= title_to_display then
				self:get_children_by_id("titlew")[1]:set_markup(title_to_display)
			end
		end,
	})

	local update_widget_icon = function(widget, stdout, _, _, _)
		stdout = string.gsub(stdout, "\n", "")
		widget:set_status(stdout == "Playing" and true or false)
	end

	local update_widget_text = function(widget, stdout, _, _, _)
		if string.find(stdout, "No players found") ~= nil then
			widget:set_text("", "")
			widget:set_visible(false)
			return
		end

		local title = stdout

		if title ~= nil then
			cur_title = title

			widget:set_text(title)
			widget:set_visible(true)
		end
	end

	watch(GET_PLAYER_STATUS_CMD, timeout, update_widget_icon, player_widget)
	watch(GET_CURRENT_MEDIA_CMD, timeout, update_widget_text, player_widget)

	--- Adds mouse controls to the widget:
	--  - left click - play/pause [TODO]
	--  - scroll up - play next song
	--  - scroll down - play previous song
	player_widget:connect_signal("button::press", function(_, _, _, button)
		if button == 1 and not is_cur_playing then
			awful.spawn(PLAY_CMD, false) -- left click
		elseif button == 1 and is_cur_playing then
			awful.spawn(PAUSE_CMD, false) -- left click
		elseif button == 4 then
			awful.spawn(NEXT_MEDIA_CMD, false) -- scroll up
		elseif button == 5 then
			awful.spawn(PREVIOUS_MEDIA_CMD, false) -- scroll down
		end
		awful.spawn.easy_async(GET_PLAYER_STATUS_CMD, function(stdout, stderr, exitreason, exitcode)
			update_widget_icon(player_widget, stdout, stderr, exitreason, exitcode)
		end)
	end)

	if show_tooltip then
		local player_tooltip = awful.tooltip({
			mode = "outside",
			preferred_positions = { "bottom" },
		})

		player_tooltip:add_to_object(player_widget)

		player_widget:connect_signal("mouse::enter", function()
			player_tooltip.markup = "\n<b>Title</b>: " .. cur_title
		end)
	end

	return player_widget
end

return setmetatable(player_widget, {
	__call = function(_, ...)
		return worker(...)
	end,
})
