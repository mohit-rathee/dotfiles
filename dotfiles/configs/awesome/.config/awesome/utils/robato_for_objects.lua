pcall(require, "luarocks.loader")
local rubato = require("rubato")
local function print(object)
	local str = ""
	for k, v in pairs(object) do
		str = str .. ("%s = %s  "):format(k, tostring(v))
	end
	-- naughty.notify({ text = str })
end

local function clone(tbl)
	local copy = {}
	for k, v in pairs(tbl) do
		copy[k] = v
	end
	return copy
end

-- local anim = rubato.timed({
-- 	duration = 0.7,
-- 	intro = 0.05,
-- 	rate = 6,
-- 	pos = 0,
-- 	-- easing = rubato.quadratic,
-- 	subscribed = function(value)
-- 		-- print(value)
-- 		naughty.notify({ text = tostring(value) })
-- 	end,
-- })
-- anim.target = 110

local timed = function(args)
	local subscribed = args.subscribed or function(_) end
	local start = args.start or {
		width = 200,
		height = 300,
		x = 10,
		y = 50,
	}
	local current = clone(start)
	local final = clone(start)
	local next = 1

	local function progress(time)
		if next == 0 then
			time = math.abs(1 - time)
		end
		-- naughty.notify({ text = tostring(time) })
		for key, target in pairs(final) do
			local from = start[key] or target
			current[key] = (1 - time) * from + target * time
		end
		print(current)
		subscribed(current)
	end
	local rubato_anim = rubato.timed({
		duration = args.duration or nil,
		intro = args.intro or nil,
		rate = args.rate or nil,
		easing = args.easing or nil,
		subscribed = progress,
	})

	local str = ""
	for k, v in pairs(rubato_anim) do
		local text = k .. " = " .. tostring(v) .. "\n"
		str = str .. text
	end
	-- naughty.notify({ text = str, timeout = 0 })
	local function animate_to(final_args)
		-- reset to 0
		-- for k, v in pairs(final_args) do
		-- 	naughty.notify({ text = k .. v })
		-- end
		-- rubato_anim.rapid_set = 0
		-- naughty.notify({ text = tostring(rubato_anim.pos) })
		-- rubato_anim.pos = 0
		-- rubato_anim.reset_values()
		start = clone(current)
		print(start)
		final = clone(final_args)
		print(final)
		-- restart animation
		if next == 1 then
			next = 0
			rubato_anim.target = 0
		else
			next = 1
			rubato_anim.target = 1
		end
		-- naughty.notify({ text = tostring(rubato_anim.pos) })
	end
	return { target = animate_to }
end

return { timed = timed }
-- local rubato_for_objects = require("widgets.robato_for_objects")
-- local new_anim = timed({
-- 	duration = 0.7,
-- 	intro = 0.05,
-- 	rate = 6,
-- 	easing = rubato.quadratic,
-- 	start = {
-- 		width = 100,
-- 		height = 100,
-- 		x = 0,
-- 		y = 0,
-- 	},
-- 	subscribed = function(object)
-- 		for k, v in pairs(object) do
-- 			naughty.notify({ text = k .. v })
-- 		end
-- 	end,
-- })
