local awful = require("awful")

local taglist_buttons = require("screen.tags.mouse")

local tags = {
	names = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "😎" },
}

local function setup(screen)
	-- Add tags to each screen
	-- Each screen has its own tag table.
	awful.tag(tags.names, screen, awful.layout.suit.tile)

	-- Create a taglist widget
	screen.mytaglist = awful.widget.taglist({
		screen = screen,
		filter = awful.widget.taglist.filter.all,
		buttons = taglist_buttons,
	})
end

return setup
