local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local battery = sbar.add("item", "widgets.battery", {
    position = "right",
    update_freq = 60,
    icon = {
        font = { family = settings.font_icon.text, size = settings.icon_size },
        padding_left = settings.padding.icon_label_item.icon.padding_left,
        padding_right = settings.padding.icon_label_item.icon.padding_right,
    },
    label = {
        font = { family = settings.font.numbers, style = "Bold", size = settings.label_size },
        padding_right = settings.padding.icon_label_item.label.padding_right,
    },
})

local battery_popup = sbar.add("item", {
    position = "popup." .. battery.name,
    label = { font = { family = settings.font.text, size = 12.0 } },
    icon = { drawing = false },
})

battery:subscribe({"routine", "power_source_change", "system_woke"}, function()
    sbar.exec("pmset -g batt", function(info)
        local found, _, charge = info:find("(%d+)%%")
        if not found then return end

        charge = tonumber(charge)
        local color = colors.green
        local charging = info:find("AC Power") ~= nil

        local icon = icons.battery._0
        if charging then
            icon = icons.battery.charging
        else
            if charge > 80 then icon = icons.battery._100
            elseif charge > 60 then icon = icons.battery._75
            elseif charge > 40 then icon = icons.battery._50
            elseif charge > 20 then icon = icons.battery._25
            else
                icon = icons.battery._0
                color = colors.red
            end
        end

        battery:set({
            icon = { string = icon, color = color },
            label = { string = string.format("%02d%%", charge) },
        })
    end)
end)

battery:subscribe("mouse.clicked", function()
    local is_drawing = battery:query().popup.drawing == "on"
    if not is_drawing then
        sbar.exec("pmset -g batt", function(info)
            local found, _, remaining = info:find(" (%d+:%d+) remaining")
            local label = found and ("Time remaining: " .. remaining) or "Calculating..."
            if info:find("AC Power") then label = "Connected to AC Power" end
            battery_popup:set({ label = { string = label } })
            battery:set({ popup = { drawing = true } })
        end)
    else
        battery:set({ popup = { drawing = false } })
    end
end)

sbar.add("bracket", "widgets.battery.bracket", { battery.name }, { background = { color = colors.bg1 } })
sbar.add("item", { position = "right", width = settings.group_paddings })
