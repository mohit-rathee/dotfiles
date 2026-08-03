local wibox = require("wibox")

local text_clock = wibox.widget.textclock()
text_clock:connect_signal("button::press", function(_, _, _, button)
	if button == 1 then
		cw.toggle()
	end
end)
return text_clock
