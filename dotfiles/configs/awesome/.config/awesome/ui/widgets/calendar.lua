local calendar_widget = require("awesome-wm-widgets.calendar-widget.calendar")

local cw = calendar_widget({
	theme = "nord",
	placement = "top_right",
	start_sunday = true,
	radius = 8,
	previous_month_button = 1,
	next_month_button = 3,
})

return cw
