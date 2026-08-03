local awful = require("awful")

-- Autostart Application
awful.spawn.with_shell("picom")
awful.spawn.with_shell("feh --bg-fill --random ~/wallpapers")
-- awful.spawn.with_shell("xmodmap ~/.Xmodmap")
--awful.spawn.with_shell("kdeconnectd")
--awful.spawn.with_shell("volctl")
--awful.spawn.with_shell("nm-applet")
-- awful.spawn.with_shell("blueman-applet")
-- awful.spawn.with_shell(..HOME.. "/.screenlayout/dual_screen.sh")
-- awful.spawn.with_shell("picom --config ~/.config/picom/picom.conf")
