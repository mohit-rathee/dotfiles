-- GLOBAL VARIABLES

Home = os.getenv("HOME")
Terminal = "alacritty"
Editor = os.getenv("EDITOR") or "nvim"
Editor_cmd = Terminal .. " -e " .. Editor

-- Default modkey (ALT)
Modkey = "Mod1"
