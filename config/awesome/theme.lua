local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()
local theme = dofile(themes_path.."gtk/theme.lua")

theme.font          = "iA Writer Duo S 8.1"

theme.wallpaper = "~/.config/awesome/background.png"

-- -- Define the icon theme for application icons. If not set then the icons
-- -- from /usr/share/icons and /usr/share/icons/hicolor will be used.
-- theme.icon_theme = nil

return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
