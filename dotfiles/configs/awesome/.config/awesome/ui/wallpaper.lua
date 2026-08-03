local gears = require("gears")

local function set_wallpaper(s)
	local wallpaper = Home .. "/wallpapers/0008.jpg"
	-- If wallpaper is a function, call it with the screen
	if type(wallpaper) == "function" then
		wallpaper = wallpaper(s)
	end
	gears.wallpaper.maximized(wallpaper, s, true)
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

return set_wallpaper
