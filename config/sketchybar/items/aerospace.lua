local sbar = require("sketchybar")
local colors = require("colors") 
local app_icons = require("helpers.app_icons")
local log = require("helpers.log").new("aerospaces")
local cjson = require("cjson") 
local settings = require("settings")

log.info("aerospaces.lua loading...")
-- aerospace helpers
local function decode(str)
    if type(str) == "table" then return str end
    local ok, val = pcall(cjson.decode, str)
    if not ok then return nil, "JSON Decode Error: " .. tostring(val) end
    return val
end
-- ==========================================
-- 查询并解析所有工作区信息的 JSON
-- ==========================================
local function query_workspaces()
    local cmd = [[/opt/homebrew/bin/aerospace list-workspaces --all --format "%{workspace-is-focused}%{workspace-is-visible}%{workspace}%{monitor-appkit-nsscreen-screens-id}%{monitor-name}" --json]]
    local handle = io.popen(cmd)
    if not handle then return {} end
    local json_str = handle:read("*a")
    handle:close()
    if not json_str or json_str == "" then return {} end

    local data, err = decode(json_str)
    if err then
        log.error("query_workspaces: " .. err)
        return {}
    end
    return data
end

-- ==========================================
-- 获取 AeroSpace 模式 (Mode)
-- 参数: current_only (boolean) - 是否仅获取当前激活的模式
-- 返回值: 如果 current_only 为 true，返回字符串；否则返回包含所有模式的 Table
-- ==========================================
local function list_modes(current_only) 
    -- 1. 根据参数拼接 Shell 命令
    local cmd = current_only and "/opt/homebrew/bin/aerospace list-modes --current" or "/opt/homebrew/bin/aerospace list-modes"
    
    -- 2. 同步执行命令并读取输出
    local handle = io.popen(cmd)
    if not handle then 
        return current_only and "" or {} 
    end
    local result = handle:read("*a")
    handle:close()

    if not result or result == "" then
        return current_only and "" or {} 
    end

    -- 3. 解析结果
    local modes = {}
    -- 按行切割输出结果
    for mode in result:gmatch("[^\r\n]+") do
        table.insert(modes, mode)
    end

    -- 如果只查询 current，直接返回第一个字符串结果，方便后续判断
    if current_only then
        return modes[1] or ""
    end

    -- 如果是查询全部，则返回数组
    return modes
end


-- ==========================================
-- 获取 AeroSpace 所有窗口信息
-- 返回值: 包含所有窗口信息的 Lua Table 数组
-- ==========================================
local function list_all_windows()
    -- 拼接包含指定格式的 JSON 命令
    local cmd = [[/opt/homebrew/bin/aerospace list-windows --all --json --format "%{window-id}%{app-name}%{window-title}%{workspace}"]]
    
    local handle = io.popen(cmd)
    if not handle then return {} end
    local json_str = handle:read("*a")
    handle:close()
    -- 防止空输出
    if not json_str or json_str == "" then return {} end
    -- cjson 已经帮我们把 JSON 数组转换成了 Lua Table，直接返回即可
    return decode(json_str)
end

-- ==========================================
-- 获取 AeroSpace 当前聚焦的工作区
-- 返回值: 当前工作区的名称 (字符串)
-- ==========================================
local function list_current()
    local cmd = "/opt/homebrew/bin/aerospace list-workspaces --focused"
    local handle = io.popen(cmd)
    
    -- 如果命令执行失败，返回空字符串
    if not handle then return "" end
    
    local result = handle:read("*a")
    handle:close()

    -- 防止没有输出
    if not result or result == "" then return "" end

    -- 使用 Lua 模式匹配去除首尾的空格和换行符 (\n)
    -- 例如把 "1\n" 变成 "1"
    local current_workspace = result:match("^%s*(.-)%s*$")
    
    return current_workspace or ""
end

-- Build NSScreen ID to SketchyBar display position mapping (ONCE at startup)
-- AeroSpace uses NSScreen IDs, SketchyBar uses left-to-right physical positions
local nsscreen_to_display = {}
local mapping_complete = false
local log_file = "/tmp/sketchybar_workspaces.log"

-- Debounce display_change events to prevent rapid-fire during monitor connect/disconnect
local display_change_pending = false
local DEBOUNCE_DELAY = 1.0  -- seconds

local function log_mapping(msg)
    local f = io.open(log_file, "a")
    if f then
        f:write(os.date("%H:%M:%S") .. " " .. msg .. "\n")
        f:close()
    end
end

-- Build the mapping synchronously at startup
local function build_monitor_mapping()
    local ok, err = pcall(function()
        log.info("build_monitor_mapping: starting")
        -- Query workspaces to get NSScreen IDs and build the mapping
        local workspace_info = query_workspaces()
        if not workspace_info or type(workspace_info) ~= "table" then
            log.warn("build_monitor_mapping: query_workspaces returned invalid data: %s", type(workspace_info))
            return
        end
        local processed = {}
        nsscreen_to_display = {} -- Clear old mapping
        for _, ws in ipairs(workspace_info) do
            local nsscreen_id_raw = ws["monitor-appkit-nsscreen-screens-id"]
            if nsscreen_id_raw then
                local nsscreen_id = math.floor(nsscreen_id_raw)
                local monitor_name = ws["monitor-name"] or ""
                monitor_name = monitor_name:match("^%s*(.-)%s*$")

                if not processed[nsscreen_id] then
                    -- Use NSScreen ID directly as SketchyBar display index
                    nsscreen_to_display[nsscreen_id] = nsscreen_id
                    processed[nsscreen_id] = true
                    log_mapping(string.format("[MAPPING] NSScreen %d (%s) -> display %d", nsscreen_id, monitor_name, nsscreen_to_display[nsscreen_id]))
                end
            end
        end
        mapping_complete = true
        log_mapping("[MAPPING] Complete")
        log.info("build_monitor_mapping: completed successfully")
    end)
    if not ok then
        log.error("build_monitor_mapping FAILED: %s", tostring(err))
    end
end

-- Build mapping synchronously before anything else
build_monitor_mapping()

-- Root is used to handle event subscriptions
local root = sbar.add("item", { drawing = false })
local workspaces = {}
local workspace_cache = {}

-- AeroSpace mode indicator
local mode_indicator = sbar.add("item", "aerospace.mode", {
    position = "left",
    icon = {
        string = "M",
        color = colors.green,
        font = {
            family = settings.font.text,
            style = settings.font.style_map["Bold"],
            size = 14.0,
        },
        padding_left = 8,
        padding_right = 8,
    },
    label = { drawing = false },
    background = {
        color = colors.bg1,
        drawing = true,
    },
})

local function update_mode_indicator()
    -- Query current mode using AeroSpaceLua API
    local current_mode = list_modes(true)
    current_mode = current_mode:match("^%s*(.-)%s*$")
    
    local styles = {
        main = { icon = "M", color = colors.green },
        service = { icon = "S", color = colors.yellow }
    }
    
    local style = styles[current_mode] or styles.main

    mode_indicator:set({
        icon = {
            string = style.icon,
            color = style.color
        }
    })
end

mode_indicator:subscribe("aerospace_mode_change", function(env)
    update_mode_indicator()
end)

-- Initialize mode on startup
update_mode_indicator()

local function updateWindows()
    log.debug("updateWindows: entering")
    sbar.exec([[/opt/homebrew/bin/aerospace list-windows --all --json --format "%{window-id}%{app-name}%{window-title}%{workspace}"]], function(res_w)
        log.debug("updateWindows: windows data received" .. type(res_w))
        sbar.exec([[ /opt/homebrew/bin/aerospace list-workspaces --all --format "%{workspace-is-focused}%{workspace-is-visible}%{workspace}%{monitor-appkit-nsscreen-screens-id}" --json ]], function(res_ws)
            log.debug("updateWindows: workspaces data received")
            
            local function get_data(res)
                if type(res) == "string" then return res end
                if type(res) == "table" and res.stdout then return res.stdout end
                if type(res) == "table" then return res end
                return ""
            end

            local windows_raw = get_data(res_w)
            local workspaces_raw = get_data(res_ws)

            local windows, err_w = decode(windows_raw)
            local workspace_info, err_ws = decode(workspaces_raw)
            
            if not (windows and workspace_info) then 
                log.error(string.format("updateWindows: Decode failed. Windows Err: %s | Workspaces Err: %s", tostring(err_w), tostring(err_ws)))
                return 
            end

            local open_windows = {}
            for _, window in ipairs(windows) do
                local ws = tostring(window.workspace)
                if ws and ws ~= "nil" then
                    open_windows[ws] = open_windows[ws] or {}
                    table.insert(open_windows[ws], window["app-name"])
                end
            end

            sbar.animate("tanh", 10.0, function()
                for _, info in ipairs(workspace_info) do
                    local ws_name = tostring(info.workspace)
                    local item = workspaces[ws_name]
                    
                    if item then
                        local apps = open_windows[ws_name] or {}
                        local is_focused = info["workspace-is-focused"] == true
                        local is_visible = info["workspace-is-visible"] == true
                        
                        local icon_line = ""
                        local no_app = true
                        for _, app in ipairs(apps) do
                            no_app = false
                            local icon = app_icons[app] or app_icons["Default"]
                            icon_line = icon_line .. " " .. icon
                        end

                        local drawing = true
                        if no_app then
                            if is_visible or is_focused then
                                icon_line = " —"
                            else
                                drawing = false
                            end
                        end

                        local nsscreen_id = math.floor(info["monitor-appkit-nsscreen-screens-id"] or 0)
                        local display_id = nsscreen_to_display[nsscreen_id]
                        
                        local props = {
                            drawing = drawing,
                            icon = { highlight = is_focused },
                            label = { string = icon_line, highlight = is_focused }
                        }
                        
                        if display_id and type(display_id) == "number" and display_id > 0 then 
                            props.display = tostring(math.floor(display_id))
                        end
                        
                        log.debug(string.format("Setting WS %s -> drawing: %s, focused: %s, label: '%s', display: %s", ws_name, tostring(drawing), tostring(is_focused), icon_line, tostring(props.display)))
                        item:set(props)
                    end
                end
            end)
        end)
    end)
end

local function updateWorkspaceMonitor()
    local workspace_info = query_workspaces()
    if not workspace_info or type(workspace_info) ~= "table" then
        log.warn("updateWorkspaceMonitor: invalid workspace_info")
        return
    end
    for _, ws in ipairs(workspace_info) do
        local space_index = tostring(ws.workspace)
        local nsscreen_id_raw = ws["monitor-appkit-nsscreen-screens-id"]
        if nsscreen_id_raw then
            local nsscreen_id = math.floor(nsscreen_id_raw)
            local display_id = nsscreen_to_display[nsscreen_id]
            -- Only set display if we have a valid mapping and workspace exists
            if workspaces[space_index] and display_id and type(display_id) == "number" and display_id > 0 then
                workspaces[space_index]:set({
                    display = tostring(math.floor(display_id)),
                })
            end
        end
    end
end

-- Initialize workspaces
log.info("Initialize workspaces: starting")
local workspace_info = query_workspaces()
log.info(string.format("Initialize workspaces: found %d workspaces", #workspace_info))

for _, entry in ipairs(workspace_info) do
    local workspace_index = tostring(entry.workspace)
    log.debug(string.format("Adding workspace item: %s", workspace_index))

    local workspace = sbar.add("item", "workspace." .. workspace_index, {
        position = "left",
        background = {
            color = colors.bg1,
            drawing = true,
        },
        click_script = "/opt/homebrew/bin/aerospace workspace " .. workspace_index .. " 2>/dev/null",
        drawing = false, -- Hide all items at first
        icon = {
            color = colors.with_alpha(colors.white, 0.3),
            drawing = true,
            font = { family = settings.font.numbers },
            highlight_color = colors.white,
            padding_left = 5,
            padding_right = 4,
            string = workspace_index
        },
        label = {
            color = colors.with_alpha(colors.white, 0.3),
            drawing = true,
            font = "sketchybar-app-font:Regular:16.0",
            highlight_color = colors.white,
            padding_left = 2,
            padding_right = 12,
            y_offset = -1,
        },
    })

    workspaces[workspace_index] = workspace
end

-- Initial setup
log.info("Initial setup: calling updateWindows and updateWorkspaceMonitor")
updateWindows()
updateWorkspaceMonitor()

-- Helper to wrap event handlers with error handling
local function safe_handler(event_name, handler)
    return function(env)
        local ok, err = pcall(handler, env)
        if not ok then
            log.error("EVENT HANDLER FAILED: %s - %s", event_name, tostring(err))
        end
    end
end

-- Subscribe to window creation/destruction events
log.info("subscribing to aerospace_workspace_change")
root:subscribe("aerospace_workspace_change", safe_handler("aerospace_workspace_change", function(env)
    log.debug("EVENT: aerospace_workspace_change received")
    updateWindows()
end))

-- Subscribe to front app changes too
root:subscribe("front_app_switched", safe_handler("front_app_switched", function()
    log.debug("EVENT: front_app_switched")
    updateWindows()
end))

root:subscribe("display_change", safe_handler("display_change", function()
    -- Debounce: skip if a rebuild is already pending
    if display_change_pending then
        log.info("EVENT: display_change - debounced (already pending)")
        return
    end
    display_change_pending = true
    log.info("EVENT: display_change - scheduling rebuild in %ss", DEBOUNCE_DELAY)

    sbar.exec("sleep " .. DEBOUNCE_DELAY, function()
        display_change_pending = false
        log.info("EVENT: display_change - executing rebuild")

        -- Clear stale mappings before rebuild
        nsscreen_to_display = {}
        mapping_complete = false

        build_monitor_mapping()

        -- Only proceed if mapping succeeded
        if mapping_complete then
            updateWorkspaceMonitor()
            updateWindows()
        else
            log.warn("EVENT: display_change - mapping failed, skipping updates")
        end
        log.info("EVENT: display_change - completed")
    end)
end))

local focused_workspace = list_current()
if workspaces[focused_workspace] then
    workspaces[focused_workspace]:set({
        icon = { highlight = true },
        label = { highlight = true },
    })
end
