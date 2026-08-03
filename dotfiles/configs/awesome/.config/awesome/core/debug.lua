local naughty = require("naughty")

local LOG_FILE = Home .. "/.cache/awesome/debug.log"

Debug = {}

function Debug.notify(text, timeout)
	naughty.notify({
		text = tostring(text),
		timeout = timeout or 5,
	})
end

function Debug.log(...)
	local f, err = io.open(LOG_FILE, "a")
	if not f then
		naughty.notify({
			title = "Debug Log Error",
			text = tostring(err),
		})
		return
	end

	local args = { ... }
	local parts = {}

	for i, v in ipairs(args) do
		parts[i] = tostring(v)
	end

	local date = os.date("[%d-%m-%Y %H:%M:%S] ")
	f:write(tostring(date))
	f:write(table.concat(parts, " "))
	f:write("\n")
	f:close()
end

function Debug.clear_log()
	os.remove(LOG_FILE)
end

Notify = Debug.notify
Log = Debug.log

print("Debug helpers loaded")
