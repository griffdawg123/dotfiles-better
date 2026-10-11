-- ┏━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┓
-- ┃                    Hyprland Configuration                   ┃
-- ┗━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┛
--
-- modules/  shared by every machine
-- hosts/    per-machine overrides; ansible links the right one to ./host
--
-- Each module runs in its own scope, so an error in one doesn't stop the
-- others from loading. API stubs: /usr/share/hypr/stubs/hl.meta.lua

require("modules.env")
require("modules.monitors").setup()
require("modules.look")
require("modules.input")
require("modules.keybinds")
require("modules.rules")
require("modules.autostart")

-- Loaded last so host settings override the shared ones. Missing on a
-- machine that hasn't been through ansible yet, which is fine.
local ok, err = pcall(require, "host.init")
if not ok and not tostring(err):find("not found") then
    error(err)
end
