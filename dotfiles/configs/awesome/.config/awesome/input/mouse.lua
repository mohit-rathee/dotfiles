local gears = require("gears")
local awful = require("awful")

local scroll_up = awful.button({}, 4, awful.tag.viewnext)
local scroll_down = awful.button({}, 5, awful.tag.viewprev)
local mouse_buttons = gears.table.join(scroll_up, scroll_down)

return mouse_buttons
