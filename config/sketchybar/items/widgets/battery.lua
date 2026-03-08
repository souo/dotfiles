local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Battery indicator item
local battery = sbar.add("item", "widgets.battery", {
    position = "right",
    update_freq = 60, -- 1分钟更新一次即可
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

local remaining_time = sbar.add("item", {
    position = "popup." .. battery.name,
    icon = {
        string = "Time remaining:",
        align = "left",
        font = { family = settings.font.text, size = settings.font.size },
    },
    label = { string = "??:??h", align = "right" },
})

battery:subscribe({ "routine", "power_source_change", "system_woke" }, function()
    sbar.exec("pmset -g batt", function(batt_info)
        local found, _, charge = batt_info:find("(%d+)%%")
        if not found then return end
        
        charge = tonumber(charge)
        local color = colors.green
        local charging = batt_info:find("AC Power") ~= nil

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
                color = colors.red -- 极低电量变红
            end
        end

        battery:set({
            icon = { string = icon, color = color },
            label = { string = string.format("%02d%%", charge) },
        })
    end)
end)

battery:subscribe("mouse.clicked", function(env)
    local drawing = battery:query().popup.drawing
    battery:set({ popup = { drawing = "toggle" } })

    if drawing == "off" then
        sbar.exec("pmset -g batt", function(batt_info)
            local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
            remaining_time:set({ label = { string = found and remaining .. "h" or "Calculating..." } })
        end)
    end
end)
