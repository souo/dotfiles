local sbar = require("sketchybar")
local colors = require("colors")
local icon_map = require("helpers.icon_map")
local log = require("helpers.log").new("aerospaces")
local settings = require("settings")
local cjson = require("cjson")

log.info("aerospaces.lua: Smart Fallback version loading...")

local AEROSPACE_PATH = "/opt/homebrew/bin/aerospace"
local workspaces = {}
local update_pending = false

-- Helper: Get stylized first letter or standard icon
local function get_icon(app_name)

    -- Check standard library
    if icon_map[app_name] then return icon_map[app_name] end

    return icon_map["Default"] or ":default:"
end

-- Indicator
local mode_indicator = sbar.add("item", "aerospace.mode", {
    position = "left",
    icon = { string = "M", color = colors.green, font = { family = settings.font.text, style = "Bold", size = 14.0 }, padding_left = 8, padding_right = 8 },
    label = { drawing = false },
    background = { color = colors.bg1, drawing = true },
    drawing = false,
})

local function update_mode()
    sbar.exec(AEROSPACE_PATH .. " list-modes --current", function(mode, exit_code)
        if exit_code ~= 0 or not mode or mode == "" or mode:find("Can't connect") then
            mode_indicator:set({ drawing = false })
            return
        end
        local current_mode = (tostring(mode) or ""):gsub("%s+", "")
        local styles = { main = { icon = "M", color = colors.green }, service = { icon = "S", color = colors.yellow } }
        local style = styles[current_mode] or styles.main
        mode_indicator:set({ drawing = true, icon = { string = style.icon, color = style.color } })
    end)
end

-- Ensure Item
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

local function hide_all()
    mode_indicator:set({ drawing = false })
    for _, item in pairs(workspaces) do item:set({ drawing = false }) end
end

local function decode(obj)
    if type(obj) == "table" then return obj end
    if type(obj) ~= "string" or obj == "" then return nil end
    local json_start = obj:find("[%[{]")
    if not json_start then return nil end
    return pcall(cjson.decode, obj:sub(json_start)) and cjson.decode(obj:sub(json_start)) or nil
end

-- Key-agnostic getter
local function get_any(t, key)
    if type(t) ~= "table" then return nil end
    local k_underscore = key:gsub("-", "_")
    return t[k_underscore] or t[key]
end

-- Main Update
local function update_workspaces()
    if update_pending then return end
    update_pending = true

    sbar.exec("pgrep -x AeroSpace", function(pgrep_res, exit_code)
        if exit_code ~= 0 then
            update_pending = false
            hide_all()
            return
        end

        local win_cmd = AEROSPACE_PATH .. [[ list-windows --all --json --format "%{window-id}%{app-name}%{workspace}" ]]
        local ws_cmd = AEROSPACE_PATH .. [[ list-workspaces --all --json --format "%{workspace-is-focused}%{workspace-is-visible}%{workspace}%{monitor-appkit-nsscreen-screens-id}" ]]

        sbar.exec(win_cmd, function(win_raw)
            sbar.exec(ws_cmd, function(ws_raw)
                update_pending = false
                local win_data = decode(win_raw)
                local ws_data = decode(ws_raw)
                if not ws_data then hide_all() return end

                local ws_windows = {}
                if win_data then
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
                                icon_line = icon_line .. " " .. get_icon(app)
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

local root = sbar.add("item", "aerospace.root", { drawing = false, update_freq = 2 })
root:subscribe({"aerospace_workspace_change", "front_app_switched", "display_change", "aerospace_mode_change", "routine", "forced"}, function()
    update_workspaces()
    update_mode()
end)

update_workspaces()
update_mode()
