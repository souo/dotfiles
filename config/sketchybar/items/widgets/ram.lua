local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local ram = sbar.add("item", "widgets.ram", {
    position = "right",
    update_freq = 5,
    icon = {
        string = icons.memory,
        font = { family = settings.font_icon.text, size = settings.icon_size },
        padding_left = settings.padding.icon_label_item.icon.padding_left,
        padding_right = settings.padding.icon_label_item.icon.padding_right,
    },
    label = {
        font = { family = settings.font.numbers, style = "Bold", size = settings.label_size },
        padding_right = settings.padding.icon_label_item.label.padding_right,
    },
})

ram:subscribe({"routine", "forced"}, function()
    -- Optimized: Calculate percentage directly in shell to reduce Lua overhead
    local cmd = [[memory_pressure | awk '/System-wide memory free percentage:/ { printf("%d", 100-$5) }']]

    sbar.exec(cmd, function(percent_str)
        local percent = tonumber(percent_str) or 0
        local color = colors.accent
        if percent > 85 then color = colors.red
        elseif percent > 70 then color = colors.orange
        elseif percent > 50 then color = colors.yellow
        end

        ram:set({
            icon = { color = color },
            label = { string = string.format("%02d%%", percent) }
        })
    end)
end)

ram:subscribe("mouse.clicked", function() sbar.exec("open -a 'Activity Monitor'") end)

sbar.add("bracket", "widgets.ram.bracket", { ram.name }, { background = { color = colors.bg1 } })
sbar.add("item", { position = "right", width = settings.group_paddings })
