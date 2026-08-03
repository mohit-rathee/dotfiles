local gears = require("gears")

local global_keys = require("input.keys")
local tag_keys = require("screen.tags.keys")
local remaps = require("input.remaps")
-- import more tables of awful.key() and add in all_keys

local mouse_buttons = require("input.mouse")

local all_keys = gears.table.join(global_keys, tag_keys, remaps)

root.keys(all_keys)
root.buttons(mouse_buttons)
