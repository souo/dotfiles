local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local LABEL_WIDTH = 60

local network_base = sbar.add("item", "widgets.network.base", {
    position = "right",
    label = { drawing = false },
    icon = { drawing = false },
})

local network_up = sbar.add("item", "widgets.network.up", {
    position = "right",
    width = 0,
    icon = {
        string = icons.wifi.upload,
        font = { size = 9.0 },
        color = colors.red,
        padding_right = 2,
    },
    label = {
        font = { family = settings.font.numbers, style = "Bold", size = 9.0 },
        width = LABEL_WIDTH,
        align = "left",
        string = "???",
        color = colors.white,
    },
    y_offset = 4,
})

local network_down = sbar.add("item", "widgets.network.down", {
    position = "right",
    icon = {
        string = icons.wifi.download,
        font = { size = 9.0 },
        color = colors.blue,
        padding_right = 2,
    },
    label = {
        font = { family = settings.font.numbers, style = "Bold", size = 9.0 },
        width = LABEL_WIDTH,
        align = "left",
        string = "???",
        color = colors.white,
    },
    y_offset = -6,
})

sbar.exec("route -n get default 2>/dev/null | grep interface | awk '{print $2}'", function(interface)
    local iface = (interface or "en0"):gsub("%s+", "")
    if iface == "" then iface = "en0" end
    sbar.exec("killall network_load >/dev/null 2>&1; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load " .. iface .. " network_update 2.0")
end)

network_base:subscribe("network_update", function(env)
    local up = env.upload or "000 Bps"
    local down = env.download or "000 Bps"
    local up_str = up:gsub(" Bps", " B/s"):gsub("ps", "/s"):gsub(" ", "")
    local down_str = down:gsub(" Bps", " B/s"):gsub("ps", "/s"):gsub(" ", "")

    network_up:set({ label = { string = up_str } })
    network_down:set({ label = { string = down_str } })
end)

local function open_monitor() sbar.exec("open -a 'Activity Monitor'") end
network_base:subscribe("mouse.clicked", open_monitor)
network_up:subscribe("mouse.clicked", open_monitor)
network_down:subscribe("mouse.clicked", open_monitor)

sbar.add("bracket", "widgets.network.bracket", { network_base.name, network_up.name, network_down.name }, {
    background = { color = colors.bg1 }
})
sbar.add("item", { position = "right", width = settings.group_paddings })
