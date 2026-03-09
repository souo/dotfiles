local sbar = require("sketchybar")
local colors = require("colors")
local app_icons = require("helpers.app_icons")
local log = require("helpers.log").new("aerospaces")
local settings = require("settings")
local cjson = require("cjson")

log.info("aerospaces.lua: Auto-hide version loading...")

local AEROSPACE_PATH = "/opt/homebrew/bin/aerospace"
local workspaces = {}
local update_pending = false

-- Helper: Key-agnostic getter
local function get_any(t, key)
    if type(t) ~= "table" then return nil end
    local k_underscore = key:gsub("-", "_")
    if t[k_underscore] ~= nil then return t[k_underscore] end
    if t[key] ~= nil then return t[key] end
    return nil
end

-- Indicator
local mode_indicator = sbar.add("item", "aerospace.mode", {
    position = "left",
    icon = { string = "M", color = colors.green, font = { family = settings.font.text, style = "Bold", size = 14.0 }, padding_left = 8, padding_right = 8 },
    label = { drawing = false },
    background = { color = colors.bg1, drawing = true },
    drawing = false, -- Default hide
})

local function update_mode()
    sbar.exec(AEROSPACE_PATH .. " list-modes --current", function(mode, exit_code)
        -- If command fails or app not running, hide indicator
        if exit_code ~= 0 or not mode or mode == "" or mode:find("Can't connect") then
            mode_indicator:set({ drawing = false })
            return
        end

        local current_mode = (tostring(mode) or ""):gsub("%s+", "")
        local styles = { main = { icon = "M", color = colors.green }, service = { icon = "S", color = colors.yellow } }
        local style = styles[current_mode] or styles.main
        
        mode_indicator:set({ 
            drawing = true,
            icon = { string = style.icon, color = style.color } 
        })
    end)
end

-- Ensure Item exists
local function ensure_item(ws_name)
    if workspaces[ws_name] or not ws_name or ws_name == "" then return workspaces[ws_name] end
    workspaces[ws_name] = sbar.add("item", "workspace." .. ws_name, {
        position = "left",
        background = { color = colors.bg1, drawing = true },
        click_script = AEROSPACE_PATH .. " workspace " .. ws_name,
        drawing = false,
        icon = { string = ws_name, color = colors.with_alpha(colors.white, 0.3), font = { family = settings.font.numbers }, highlight_color = colors.white, padding_left = 5, padding_right = 4 },
        label = { color = colors.with_alpha(colors.white, 0.3), font = "sketchybar-app-font:Regular:16.0", highlight_color = colors.white, padding_left = 2, padding_right = 12, y_offset = -1 },
    })
    return workspaces[ws_name]
end

-- Hide everything when AeroSpace is not running
local function hide_all_workspaces()
    mode_indicator:set({ drawing = false })
    for _, item in pairs(workspaces) do
        item:set({ drawing = false })
    end
end

-- Main Update
local function update_workspaces()
    if update_pending then return end
    update_pending = true

    -- Check if AeroSpace is running first
    sbar.exec("pgrep -x AeroSpace", function(pgrep_res, exit_code)
        if exit_code ~= 0 then
            update_pending = false
            hide_all_workspaces()
            return
        end

        -- AeroSpace is running, proceed with data fetch
        local win_cmd = AEROSPACE_PATH .. [[ list-windows --all --json --format "%{window-id}%{app-name}%{workspace}" ]]
        local ws_cmd = AEROSPACE_PATH .. [[ list-workspaces --all --json --format "%{workspace-is-focused}%{workspace-is-visible}%{workspace}%{monitor-appkit-nsscreen-screens-id}" ]]

        sbar.exec(win_cmd, function(win_data)
            sbar.exec(ws_cmd, function(ws_data)
                update_pending = false
                
                if type(ws_data) ~= "table" then 
                    hide_all_workspaces()
                    return 
                end

                local ws_windows = {}
                if type(win_data) == "table" then
                    for _, win in ipairs(win_data) do
                        local ws = tostring(get_any(win, "workspace") or "")
                        if ws ~= "" then
                            ws_windows[ws] = ws_windows[ws] or {}
                            table.insert(ws_windows[ws], get_any(win, "app-name"))
                        end
                    end
                end

                sbar.animate("tanh", 10.0, function()
                    for _, info in ipairs(ws_data) do
                        local ws_name = tostring(get_any(info, "workspace") or "")
                        local item = ensure_item(ws_name)
                        if item then
                            local apps = ws_windows[ws_name] or {}
                            local is_focused = get_any(info, "workspace-is-focused") == true
                            local is_visible = get_any(info, "workspace-is-visible") == true
                            
                            local icon_line = ""
                            for _, app in ipairs(apps) do
                                icon_line = icon_line .. " " .. (app_icons[app] or app_icons["Default"] or ":default:")
                            end

                            local drawing = true
                            if #apps == 0 then
                                if is_visible or is_focused then icon_line = " —" else drawing = false end
                            end

                            local nsscreen_id = math.floor(get_any(info, "monitor-appkit-nsscreen-screens-id") or 1)
                            
                            item:set({
                                drawing = drawing,
                                display = tostring(nsscreen_id),
                                icon = { highlight = is_focused },
                                label = { string = icon_line, highlight = is_focused }
                            })
                        end
                    end
                end)
            end)
        end)
    end)
end

-- Subscriptions
local root = sbar.add("item", "aerospace.root", { drawing = false, update_freq = 2 })
root:subscribe({"aerospace_workspace_change", "front_app_switched", "display_change", "aerospace_mode_change", "routine", "forced"}, function()
    update_workspaces()
    update_mode()
end)

-- Start
update_workspaces()
update_mode()
