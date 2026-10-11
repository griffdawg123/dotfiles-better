-- The desk monitors, shared by every machine that docks there. Matched by
-- description rather than port, because the same screens show up as
-- HDMI-A-1/DP-1 on the desktop and DP-10/DP-9 through the laptop's dock.
--
-- Workspaces: the left screen only ever shows workspace 1; everything else
-- (2-10) lives on the primary screen.

local M = {
    left    = "desc:BNQ BenQ GL2480",
    primary = "desc:BNQ BenQ GL2580",
}

-- Monitor each workspace is pinned to.
function M.home_of(ws)
    return ws == 1 and M.left or M.primary
end

-- Called once from hyprland.lua. Kept out of module load so host files can
-- require this module for the names/helpers without re-adding the rules.
function M.setup()
    hl.monitor({ output = M.left,    mode = "preferred", position = "0x0",    scale = 1 })
    hl.monitor({ output = M.primary, mode = "preferred", position = "1920x0", scale = 1 })

    -- Anything else (other docks, projectors) goes on the right.
    hl.monitor({ output = "", mode = "preferred", position = "auto-right", scale = 1 })

    -- Pins to an absent monitor are ignored, so these are harmless undocked.
    for ws = 1, 10 do
        hl.workspace_rule({
            workspace = tostring(ws),
            monitor   = M.home_of(ws),
            default   = ws == 1 or ws == 2,
        })
    end
end

return M
