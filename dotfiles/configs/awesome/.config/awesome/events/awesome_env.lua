local awful = require("awful")

--Updating env variable
awesome.connect_signal("exit", function()
	awful.util.spawn("export awesome= ")
end)

awesome.connect_signal("startup", function()
	awful.util.spawn("export awesome=yes")
end)
