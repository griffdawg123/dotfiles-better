-- The desk monitors, shared by every machine that docks there. Matched by
-- description rather than port, because the same screens show up as
-- HDMI-A-1/DP-1 on the desktop and DP-10/DP-9 through the laptop's dock.
-- Workspace pinning differs per machine, so it lives in hosts/<profile>.

local M = {
    left    = "desc:BNQ BenQ GL2480",
    primary = "desc:BNQ BenQ GL2580",
}

-- Called once from hyprland.lua. Kept out of module load so host files can
-- require this module for the names/helpers without re-adding the rules.
function M.setup()
    hl.monitor({ output = M.left,    mode = "preferred", position = "0x0",    scale = 1 })
    hl.monitor({ output = M.primary, mode = "preferred", position = "1920x0", scale = 1 })

    -- Anything else (other docks, projectors) goes on the right.
    hl.monitor({ output = "", mode = "preferred", position = "auto-right", scale = 1 })
end

-- Pin workspaces to monitors. `layout` is a list of { monitor, first, last }.
function M.pin_workspaces(layout, opts)
    opts = opts or {}
    for _, group in ipairs(layout) do
        local monitor, first, last = group[1], group[2], group[3]
        for ws = first, last do
            hl.workspace_rule({
                workspace  = tostring(ws),
                monitor    = monitor,
                default    = ws == first,
                persistent = opts.persistent or nil,
            })
        end
    end
end

return M
